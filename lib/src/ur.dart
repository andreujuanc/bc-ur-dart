// import { InvalidTypeError } from "./errors";
// import { isURType } from "./utils";
// import { cborEncode, cborDecode } from './cbor';

import 'package:bc_ur/src/errors.dart';
import 'package:bc_ur/src/utils.dart';

class UR {
  List<int> _cborPayload;
  late String _type;

  UR(this._cborPayload, String? type) {
    _type = type ?? "bytes";
    if (!isURType(_type)) {
      throw InvalidTypeError();
    }
  }

  // public static fromBuffer(buf: Buffer) {
  //   return new UR(cborEncode(buf));
  // }

  // public static from(value: any, encoding?: BufferEncoding) {
  //   return UR.fromBuffer(Buffer.from(value, encoding));
  // }

  // public decodeCBOR(): Buffer {
  //   return cborDecode(this._cborPayload);
  // }

  String get type => _type;
  List<int> get cbor => _cborPayload;

  // public equals(ur2: UR) {
  //   return this.type === ur2.type && this.cbor.equals(ur2.cbor);
  // }
}
