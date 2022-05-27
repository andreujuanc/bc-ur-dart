// import { InvalidTypeError } from "./errors";
// import { isURType } from "./utils";
// import { cborEncode, cborDecode } from './cbor';

import 'package:bc_ur/src/errors.dart';
import 'package:bc_ur/src/utils.dart';
import 'package:collection/collection.dart';

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

  Function eqList = const ListEquality().equals;
  bool equals(UR ur2) {
    return type == ur2.type && eqList(cbor, ur2.cbor);
  }
}
