import 'package:bc_ur/src/jsport.dart';
import 'package:cbor/simple.dart';

List<int> cborEncode(data) {
  return cbor.encode(data);
}

Object? cborDecode({List<int>? buffer, String? string}) {
  if (buffer != null) {
    return cbor.decode(buffer);
  } else if (string != null) {
    return cbor.decode(Buffer.from(string, 'hex'));
  }
  throw Exception('Either buffer or string must be provided');
}
