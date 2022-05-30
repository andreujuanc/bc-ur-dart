// import assert from "assert";
// import { bufferXOR, getCRC, split, toUint32 } from "./utils";
// import { chooseFragments } from "./fountainUtils";
// import { cborEncode, cborDecode } from './cbor';

import 'dart:typed_data';

import 'package:bc_ur/src/cbor.dart';
import 'package:bc_ur/src/fountainUtils.dart';
import 'package:bc_ur/src/jsport.dart';
import 'package:bc_ur/src/utils.dart';

class FountainEncoderPart {
  int seqNum;
  int seqLength;
  int messageLength;
  BigInt checksum;
  List<int> fragment;

  FountainEncoderPart(
    this.seqNum,
    this.seqLength,
    this.messageLength,
    this.checksum,
    this.fragment,
  );

//   get messageLength() { return this._messageLength; }
//   get fragment() { return this._fragment; }
//   get seqNum() { return this._seqNum; }
//   get seqLength() { return this._seqLength; }
//   get checksum() { return this._checksum; }

  List<int> cbor() {
    final result = cborEncode([seqNum, seqLength, messageLength, checksum.toInt(), fragment]);

    return result;
  }

//   public description(): string {
//     return `seqNum:${this._seqNum}, seqLen:${this._seqLength}, messageLen:${this._messageLength}, checksum:${this._checksum}, data:${this._fragment.toString('hex')}`
//   }

  static FountainEncoderPart fromCBOR(String cborPayload) {
    final decoded = cborDecode(string: cborPayload);
    if (decoded == null) throw Exception('Invalid CBOR payload');

    final seqNum = decoded[0];
    final seqLength = decoded[1];
    final messageLength = decoded[2];
    final checksum = decoded[3];
    final fragment = decoded[4] as List<Object?>;

    // assert(typeof seqNum === 'number');
    // assert(typeof seqLength === 'number');
    // assert(typeof messageLength === 'number');
    // assert(typeof checksum === 'number');
    // assert(Buffer.isBuffer(fragment) && fragment.length > 0);

    return FountainEncoderPart(
      seqNum,
      seqLength,
      messageLength,
      BigInt.from(checksum),
      fragment.map((e) => e as int).toList(),
    );
  }
}

class FountainEncoder {
  late int _messageLength;
  late List<List<int>> _fragments;
  late int fragmentLength;
  late int seqNum;
  late BigInt checksum;

  FountainEncoder(List<int> message, {int? maxFragmentLength, int? firstSeqNum, int? minFragmentLength}) {
    maxFragmentLength ??= 100;
    firstSeqNum ??= 0;
    minFragmentLength ??= 10;

    var _fragmentLength =
        FountainEncoder.findNominalFragmentLength(message.length, minFragmentLength, maxFragmentLength);

    _messageLength = message.length;
    _fragments = FountainEncoder.partitionMessage(message, _fragmentLength);
    fragmentLength = _fragmentLength;
    seqNum = toUint32(firstSeqNum);
    checksum = getCRC(message);
  }

//   public get fragmentsLength() { return this._fragments.length; }
//   public get fragments() { return this._fragments; }
//   public get messageLength() { return this._messageLength; }

  bool isComplete() {
    return this.seqNum >= this._fragments.length;
  }

  bool isSinglePart() {
    return this._fragments.length == 1;
  }

  int seqLength() {
    return this._fragments.length;
  }

  mix(List<int> indexes) {
    return indexes.fold(
      List<int>.filled(fragmentLength, 0),
      (List<int> result, index) => bufferXOR(_fragments[index], result),
    );
  }

  FountainEncoderPart nextPart() {
    seqNum = toUint32(seqNum + 1);

    var indexes = chooseFragments(seqNum, _fragments.length, checksum.toInt()); // TODO this might fail?
    var mixed = mix(indexes);

    return FountainEncoderPart(this.seqNum, this._fragments.length, this._messageLength, this.checksum, mixed);
  }

  static int findNominalFragmentLength(int messageLength, int minFragmentLength, int maxFragmentLength) {
    assert(messageLength > 0);
    assert(minFragmentLength > 0);
    assert(maxFragmentLength >= minFragmentLength);

    var maxFragmentCount = (messageLength / minFragmentLength).ceil();
    var fragmentLength = 0;

    for (var fragmentCount = 1; fragmentCount <= maxFragmentCount; fragmentCount++) {
      fragmentLength = (messageLength / fragmentCount).ceil();

      if (fragmentLength <= maxFragmentLength) {
        break;
      }
    }

    return fragmentLength;
  }

  static List<List<int>> partitionMessage(List<int> message, int fragmentLength) {
    var remaining = [...message];
    List<List<int>> _fragments = [];

    while (remaining.isNotEmpty) {
      var result = split(remaining, -fragmentLength);
      var fragment = result[0];
      remaining = result[1];

      fragment = List<int>.generate(fragmentLength, (index) => index < fragment.length ? fragment[index] : 0);

      _fragments.add(fragment);
    }

    return _fragments;
  }
}
