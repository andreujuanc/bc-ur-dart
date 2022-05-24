// import assert from "assert";
// import { bufferXOR, getCRC, split, toUint32 } from "./utils";
// import { chooseFragments } from "./fountainUtils";
// import { cborEncode, cborDecode } from './cbor';

import 'package:bc_ur/src/jsport.dart';
import 'package:bc_ur/src/utils.dart';

class FountainEncoderPart {
//   constructor(
//     private _seqNum: number,
//     private _seqLength: number,
//     private _messageLength: number,
//     private _checksum: number,
//     private _fragment: Buffer,
//   ) { }

//   get messageLength() { return this._messageLength; }
//   get fragment() { return this._fragment; }
//   get seqNum() { return this._seqNum; }
//   get seqLength() { return this._seqLength; }
//   get checksum() { return this._checksum; }

//   public cbor(): Buffer {
//     var result = cborEncode([
//       this._seqNum,
//       this._seqLength,
//       this._messageLength,
//       this._checksum,
//       this._fragment
//     ])

//     return Buffer.from(result);
//   }

//   public description(): string {
//     return `seqNum:${this._seqNum}, seqLen:${this._seqLength}, messageLen:${this._messageLength}, checksum:${this._checksum}, data:${this._fragment.toString('hex')}`
//   }

//   public static fromCBOR(cborPayload: string | Buffer) {
//     var [
//       seqNum,
//       seqLength,
//       messageLength,
//       checksum,
//       fragment,
//     ] = cborDecode(cborPayload);

//     assert(typeof seqNum === 'number');
//     assert(typeof seqLength === 'number');
//     assert(typeof messageLength === 'number');
//     assert(typeof checksum === 'number');
//     assert(Buffer.isBuffer(fragment) && fragment.length > 0);

//     return new FountainEncoderPart(
//       seqNum,
//       seqLength,
//       messageLength,
//       checksum,
//       Buffer.from(fragment),
//     )
//   }
}

class FountainEncoder {
  late int _messageLength;
  late List<List<int>> _fragments;
  late int fragmentLength;
  late int seqNum;
  late BigInt checksum;

  FountainEncoder(List<int> message, {int maxFragmentLength = 100, int firstSeqNum = 0, int minFragmentLength = 10}) {
    var fragmentLength =
        FountainEncoder.findNominalFragmentLength(message.length, minFragmentLength, maxFragmentLength);

    this._messageLength = message.length;
    this._fragments = FountainEncoder.partitionMessage(message, fragmentLength);
    this.fragmentLength = fragmentLength;
    this.seqNum = toUint32(firstSeqNum);
    this.checksum = getCRC(message);
  }

//   public get fragmentsLength() { return this._fragments.length; }
//   public get fragments() { return this._fragments; }
//   public get messageLength() { return this._messageLength; }

//   public isComplete(): boolean {
//     return this.seqNum >= this._fragments.length;
//   }

//   public isSinglePart(): boolean {
//     return this._fragments.length === 1;
//   }

//   public seqLength(): number {
//     return this._fragments.length;
//   }

//   public mix(indexes: number[]) {
//     return indexes.reduce(
//       (result, index) => bufferXOR(this._fragments[index], result),
//       Buffer.alloc(this.fragmentLength, 0)
//     )
//   }

  // FountainEncoderPart nextPart() {
  //   this.seqNum = toUint32(this.seqNum + 1);

  //   var indexes = chooseFragments(this.seqNum, this._fragments.length, this.checksum);
  //   var mixed = this.mix(indexes);

  //   return new FountainEncoderPart(
  //     this.seqNum,
  //     this._fragments.length,
  //     this._messageLength,
  //     this.checksum,
  //     mixed
  //   )
  // }

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
    var fragment;
    List<List<int>> _fragments = [];

    while (remaining.isNotEmpty) {
      var result = split(remaining, -fragmentLength);
      fragment = result[0];
      remaining = result[1];

      var tmp = List<int>.generate(fragmentLength, (index) => 0);
      tmp.fillRange(0, fragment.length, fragment);
      //  .alloc(fragmentLength, 0) // initialize with 0's to achieve the padding
      //.fill(fragment, 0, fragment.length)

      _fragments.add(fragment);
    }

    return _fragments;
  }
}
