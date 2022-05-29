// import FountainEncoder, { FountainEncoderPart } from './fountainEncoder';
// import bytewords from './bytewords';
// import UR from './ur';

import 'package:bc_ur/src/bytewords.dart';
import 'package:bc_ur/src/fountainEncoder.dart';
import 'package:bc_ur/src/jsport.dart';
import 'package:bc_ur/src/ur.dart';
import 'package:convert/convert.dart';

class UREncoder {
  // these are private
  UR ur;
  late FountainEncoder fountainEncoder;

  UREncoder(
    this.ur, {
    int? maxFragmentLength,
    int? firstSeqNum,
    int? minFragmentLength,
  }) {
    fountainEncoder = FountainEncoder(ur.cbor, maxFragmentLength: maxFragmentLength, firstSeqNum: firstSeqNum, minFragmentLength: minFragmentLength);
  }

  // public get fragmentsLength() { return this.fountainEncoder.fragmentsLength; }
  // public get fragments() { return this.fountainEncoder.fragments; }
  // public get messageLength() { return this.fountainEncoder.messageLength; }
  // public get cbor() { return this.ur.cbor; }

  // public encodeWhole(): string[] {
  //   return [...new Array(this.fragmentsLength)].map(() => this.nextPart())
  // }

  String nextPart() {
    final part = fountainEncoder.nextPart();

    if (this.fountainEncoder.isSinglePart()) {
      return UREncoder.encodeSinglePart(this.ur);
    }
    else {
      return UREncoder.encodePart(this.ur.type, part);
    }
  }

  static String encodeUri(String scheme, List<String> pathComponents) {
    var path = pathComponents.join('/');
    return [scheme, path].join(':');
  }

  static String encodeUR(List<String> pathComponents) {
    return UREncoder.encodeUri('ur', pathComponents);
  }

  static String  encodePart(String type, FountainEncoderPart part) {
    final seq = '${part.seqNum}-${part.seqLength}';
    final body = Bytewords.encode(hex.encode(part.cbor()), BYTEWORD_STYLES.MINIMAL);

    return UREncoder.encodeUR([type, seq, body]);
  }

  static String encodeSinglePart(UR ur) {
    final body = Bytewords.encode(ur.cbor.toHexString(), BYTEWORD_STYLES.MINIMAL);

    return UREncoder.encodeUR([ur.type, body]);
  }
}
