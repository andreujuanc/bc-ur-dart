import 'package:bc_ur/src/bytewords.dart';
import 'package:bc_ur/src/errors.dart';
import 'package:bc_ur/src/fountainDecoder.dart';
import 'package:bc_ur/src/fountainEncoder.dart';
import 'package:bc_ur/src/jsport.dart';
import 'package:bc_ur/src/ur.dart';
import 'package:bc_ur/src/utils.dart';

class URDecoder {
  late String expected_type;
  UR? result;
  late String type;
  late FountainDecoder fountainDecoder;
  ExceptionBase? error;

  URDecoder(FountainDecoder? _fountainDecoder, String? _type) {
    fountainDecoder = _fountainDecoder ?? FountainDecoder();
    type = _type ?? 'bytes';
    assert(isURType(type), 'Invalid UR type');

    expected_type = '';
  }

  static UR decodeBody(String type, String message) {
    final cbor = Bytewords.decode(message, BYTEWORD_STYLES.MINIMAL);

    return UR(Buffer.from(cbor, 'hex'), type);
  }

  bool validatePart(String type) {
    if (expected_type.isNotEmpty) {
      return expected_type == type;
    }

    if (!isURType(type)) {
      return false;
    }

    expected_type = type;

    return true;
  }

  static UR decode(String message) {
    // const [type, components] = parse(message);
    final parsed = parse(message);
    final type = parsed[0] as String;
    final components = parsed[1] as List<String>;
    if (components.isEmpty) {
      throw InvalidPathLengthError();
    }

    final body = components[0];

    return URDecoder.decodeBody(type, body);
  }

  /** @returns [string, string[]] */
  static List parse(String message) {
    final lowercase = message.toLowerCase();
    final prefix = lowercase.substring(0, 3);

    if (prefix != 'ur:') {
      throw InvalidSchemeError();
    }

    final components = lowercase.substring(3).split('/');
    final type = components[0];

    if (components.length < 2) {
      throw InvalidPathLengthError();
    }

    if (!isURType(type)) {
      throw 'InvalidTypeError';
    }

    return [type, components.sublist(1)];
  }

  /// @returns [int, int]
  static List<int> parseSequenceComponent(String s) {
    final components = s.split('-');

    if (components.length != 2) {
      throw InvalidSequenceComponentError();
    }

    final seqNum = toUint32(int.parse(components[0]));
    final seqLength = int.parse(components[1]);

    if (seqNum < 1 || seqLength < 1) {
      throw InvalidSequenceComponentError();
    }

    return [seqNum, seqLength];
  }

  bool receivePart(String s) {
    if (result != null) {
      return false;
    }

    final parsed = URDecoder.parse(s);
    final type = parsed[0] as String;
    final components = parsed[1] as List<String>;

    if (!validatePart(type)) {
      return false;
    }

    // If this is a single-part UR then we're done
    if (components.length == 1) {
      result = URDecoder.decodeBody(type, components[0]);

      return true;
    }

    if (components.length != 2) {
      throw InvalidPathLengthError();
    }

    final seq = components[0];
    final fragment = components[1];

    final parsedSequence = URDecoder.parseSequenceComponent(seq);
    final seqNum = parsedSequence[0];
    final seqLength = parsedSequence[1];

    final cbor = Bytewords.decode(fragment, BYTEWORD_STYLES.MINIMAL);
    final part = FountainEncoderPart.fromCBOR(cbor);

    if (seqNum != part.seqNum || seqLength != part.seqLength) {
      return false;
    }

    if (!fountainDecoder.receivePart(part)) {
      return false;
    }

    if (fountainDecoder.isSuccess()) {
      result = UR(fountainDecoder.resultMessage(), type);
    } else if (fountainDecoder.isFailure()) {
      error = InvalidSchemeError();
    }

    return true;
  }

  UR resultUR() {
    return result != null ? result! : UR([], 'bytes');
  }

  bool isComplete() {
    return result != null && result!.cbor.isNotEmpty;
  }

  bool isSuccess() {
    return error != null && isComplete();
  }

  // public isError(): boolean {
  //   return error !== undefined;
  // }

  resultError() {
    return error != null ? error!.message : '';
  }

  // public expectedPartCount() {
  //   return fountainDecoder.expectedPartCount();
  // }

  // public expectedPartIndexes() {
  //   return fountainDecoder.getExpectedPartIndexes();
  // }

  // public receivedPartIndexes() {
  //   return fountainDecoder.getReceivedPartIndexes();
  // }

  // public lastPartIndexes() {
  //   return fountainDecoder.getLastPartIndexes();
  // }

  // public estimatedPercentComplete() {
  //   return fountainDecoder.estimatedPercentComplete();
  // }

  // public getProgress() {
  //   return fountainDecoder.getProgress();
  // }
}
