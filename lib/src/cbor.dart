import 'dart:typed_data';

import 'package:bc_ur/src/jsport.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:typed_data/typed_data.dart';

List<int> cborEncode(dynamic data) {
  final buff = cbor.encode(CborValue(data));
  return buff;
}

dynamic? cborDecode({List<int>? buffer, String? string}) {
  Uint8List  b2;
  
  if (buffer != null) {
    b2 = Uint8List.fromList(buffer);
  } else if (string != null) {
    b2 = Uint8List.fromList(Buffer.from(string, 'hex'));
  } else
    throw Exception('Either buffer or string must be provided');

  return cbor.decode(b2).toObject();
}
