import 'dart:typed_data';

import 'package:bc_ur/src/errors.dart';
import 'package:bc_ur/src/fountainEncoder.dart';
import 'package:bc_ur/src/fountainUtils.dart';
import 'package:bc_ur/src/utils.dart';

class FountainDecoderPart {
  final List<int> _indexes;
  final Uint8List _fragment;
  FountainDecoderPart(this._indexes, this._fragment);

  List<int> get indexes => _indexes;
  Uint8List get fragment => _fragment;

  static FountainDecoderPart fromEncoderPart(FountainEncoderPart encoderPart) {
    final indexes = chooseFragments(encoderPart.seqNum, encoderPart.seqLength, encoderPart.checksum.toInt());
    final fragment = encoderPart.fragment;

    return FountainDecoderPart(indexes, fragment);
  }

  bool isSimple() {
    return indexes.length == 1;
  }
}

typedef PartIndexes = List<int>;

class PartDict {
  final PartIndexes key;
  final FountainDecoderPart value;

  PartDict(this.key, this.value);
}

class FountainDecoder {
  /// NOTEL all these are private
  ExceptionBase? error;
  List<int>? result;
  int expectedMessageLength = 0;
  int expectedChecksum = 0;
  int expectedFragmentLength = 0;
  int processedPartsCount = 0;
  PartIndexes expectedPartIndexes = [];
  PartIndexes lastPartIndexes = [];
  PartIndexes receivedPartIndexes = [];
  List<FountainDecoderPart> queuedParts = [];
  List<PartDict> mixedParts = [];
  List<PartDict> simpleParts = [];

  bool validatePart(FountainEncoderPart part) {
    // If this is the first part we've seen
    if (expectedPartIndexes.isEmpty) {
      // Record the things that all the other parts we see will have to match to be valid.
      //[...List<int>(part.seqLength)].forEach((_, index) => expectedPartIndexes.push(index));

      expectedPartIndexes.addAll(List<int>.generate(part.seqLength, (index) => index));
      expectedMessageLength = part.messageLength;
      expectedChecksum = part.checksum.toInt();
      expectedFragmentLength = part.fragment.length;
    } else {
      // If this part's values don't match the first part's values, throw away the part
      if (expectedPartIndexes.length != part.seqLength) {
        return false;
      }
      if (expectedMessageLength != part.messageLength) {
        return false;
      }
      if (expectedChecksum != part.checksum.toInt()) {
        return false;
      }
      if (expectedFragmentLength != part.fragment.length) {
        return false;
      }
    }

    // This part should be processed
    return true;
  }

  /// NOTE: private
  FountainDecoderPart reducePartByPart(FountainDecoderPart a, FountainDecoderPart b) {
    // If the fragments mixed into `b` are a strict (proper) subset of those in `a`...
    if (arrayContains(a.indexes, b.indexes)) {
      final newIndexes = setDifference(a.indexes, b.indexes);
      final newFragment = bufferXOR(a.fragment, b.fragment);

      return FountainDecoderPart(newIndexes, newFragment);
    } else {
      // `a` is not reducable by `b`, so return a
      return a;
    }
  }

  /// NOTE: Private
  void reduceMixedBy(FountainDecoderPart part) {
    final List<PartDict> newMixed = [];

    mixedParts.map((item) => reducePartByPart(item.value, part)).forEach((reducedPart) {
      if (reducedPart.isSimple()) {
        queuedParts.add(reducedPart);
      } else {
        newMixed.add(PartDict(reducedPart.indexes, reducedPart));
      }
    });

    mixedParts = newMixed;
  }

  /// NOTE: Private
  void processSimplePart(FountainDecoderPart part) {
    // Don't process duplicate parts
    final fragmentIndex = part.indexes[0];

    if (receivedPartIndexes.contains(fragmentIndex)) {
      return;
    }

    simpleParts.add(PartDict(part.indexes, part));
    receivedPartIndexes.add(fragmentIndex);

    // If we've received all the parts
    if (arraysEqual(receivedPartIndexes, expectedPartIndexes)) {
      // Reassemble the message from its fragments
      final sortedParts = simpleParts.map((item) => item.value).toList()..sort((a, b) => (a.indexes[0] - b.indexes[0]));

      final message =
          FountainDecoder.joinFragments(sortedParts.map((part) => part.fragment).toList(), expectedMessageLength);
      final checksum = getCRC(message);

      if (checksum.toInt() == expectedChecksum) {
        result = message;
      } else {
        error = InvalidChecksumError();
      }
    } else {
      reduceMixedBy(part);
    }
  }

  /// NOTE: Private
  void processMixedPart(FountainDecoderPart part) {
    // Don't process duplicate parts
    if (mixedParts.any((item) => arraysEqual(item.key, part.indexes))) {
      return;
    }

    // Reduce this part by all the others
    FountainDecoderPart p2 = simpleParts.fold(part, (acc, item) => reducePartByPart(acc, item.value));
    p2 = mixedParts.fold(p2, (acc, item) => reducePartByPart(acc, item.value));

    // If the part is now simple
    if (p2.isSimple()) {
      // Add it to the queue
      queuedParts.add(p2);
    } else {
      reduceMixedBy(p2);

      mixedParts.add(PartDict(p2.indexes, p2));
    }
  }

  /// NOTE: Private
  void processQueuedItem() {
    if (queuedParts.isEmpty) {
      return;
    }

    final part = queuedParts.removeAt(0);

    if (part.isSimple()) {
      processSimplePart(part);
    } else {
      processMixedPart(part);
    }
  }

  static joinFragments(List<Uint8List> fragments, int messageLength) {
    return Uint8List.fromList(fragments.expand((Uint8List e) => e).toList()).sublist(0, messageLength);
  }

  bool receivePart(FountainEncoderPart encoderPart) {
    if (isComplete()) {
      return false;
    }

    if (!validatePart(encoderPart)) {
      return false;
    }

    final decoderPart = FountainDecoderPart.fromEncoderPart(encoderPart);

    lastPartIndexes = decoderPart.indexes;
    queuedParts.add(decoderPart);

    while (!isComplete() && queuedParts.length > 0) {
      processQueuedItem();
    }

    processedPartsCount += 1;

    return true;
  }

  bool isComplete() {
    return result != null && result!.isNotEmpty;
  }

  bool isSuccess() {
    return error == null && isComplete();
  }

  List<int> resultMessage() {
    return isSuccess() ? result! : [];
  }

  bool isFailure() {
    return error != null;
  }

  // public resultError() {
  //   return error ? error.message : '';
  // }

  // public expectedPartCount(): number {
  //   return expectedPartIndexes.length;
  // }

  // public getExpectedPartIndexes(): PartIndexes {
  //   return [...expectedPartIndexes]
  // }

  // public getReceivedPartIndexes(): PartIndexes {
  //   return [...receivedPartIndexes]
  // }

  // public getLastPartIndexes(): PartIndexes {
  //   return [...lastPartIndexes]
  // }

  // public estimatedPercentComplete(): number {
  //   if (isComplete()) {
  //     return 1;
  //   }

  //   final expectedPartCount = expectedPartCount();

  //   if (expectedPartCount === 0) {
  //     return 0;
  //   }

  //   // We multiply the expectedPartCount by `1.75` as a way to compensate for the facet
  //   // that `processedPartsCount` also tracks the duplicate parts that have been
  //   // processeed.
  //   return Math.min(0.99, processedPartsCount / (expectedPartCount * 1.75));
  // }

  // public getProgress(): number {
  //   if (isComplete()) {
  //     return 1;
  //   }

  //   final expectedPartCount = expectedPartCount();

  //   if (expectedPartCount === 0) {
  //     return 0;
  //   }

  //   return receivedPartIndexes.length / expectedPartCount;
  // }
}
