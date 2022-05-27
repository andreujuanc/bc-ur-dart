import 'dart:typed_data';

import 'package:bc_ur/src/jsport.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:typed_data/typed_data.dart';

List<int> cborEncode(Uint8List data) {
  final buff = cbor.encode(CborValue(data));
  return buff;
}

Object? cborDecode({List<int>? buffer, String? string}) {
  // final codec = cbor.Cbor();

  // if (buffer != null) {
  //   var b2 = Uint8Buffer()..addAll(buffer);
  //   final decoder = codec.decodeFromBuffer(b2);
  //   final list = codec.getDecodedData()!;
  //   return list;
  // } else if (string != null) {
  //   var b2 = Uint8Buffer()..addAll(Buffer.from(string, 'hex'));
  //   final decoder = codec.decodeFromBuffer(b2);
  //   final list = codec.getDecodedData()!;
  // }
  throw Exception('Either buffer or string must be provided');
}
