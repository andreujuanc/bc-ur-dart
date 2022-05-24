import 'dart:convert';
import 'package:convert/convert.dart';

class Buffer {
  static List<int> from(String value, String encoding) {
    if (encoding == 'hex') return hex.decode(value);
    if (encoding == 'utf-8') return utf8.encode(value);
    throw "Encoding not implemented $encoding";
  }
}

extension ToStringExtensions on List<int> {
  String toHexString() {
    return hex.encode(this);
  }
}
