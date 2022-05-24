import 'dart:ffi';
import 'dart:typed_data';

import 'package:bc_ur/src/jsport.dart';
import 'package:crclib/catalog.dart';
import 'package:crypto/crypto.dart';

// import 'utils'shajs from 'sha.js';
// import 'utils'{ crc32 } from 'crc';

List<int> sha256Hash(List<int> data) => sha256.convert(data).bytes;

List<String> partition(String s, int n) {
  // TODO: implement partition
  //return [];
  //return s.match(new RegExp('.{1,' + n + '}', 'g')) || [s]
  var exp = RegExp('.{1,$n}');
  var matches = exp.allMatches(s);
  return matches.map((e) => e.group(0) ?? s).toList();
}

List<List<int>> split(List<int> s, int length) =>
    [s.sublist(0, s.length - length), s.sublist(s.length - length, s.length)];

BigInt getCRC(List<int> message) => Crc32Xz().convert(message).toBigInt(); //crc32(message);

var crc = Crc32Xz();

String getCRCHex(List<int> message) =>
    crc.convert(message).toRadixString(16).padLeft(8, '0'); //.toString(16).padStart(8, '0');

int toUint32(int number) => number >>> 0;

List<int> intToBytes(int number) {
  var arr = Uint8List(4); // an Int32 takes 4 bytes
  var view = ByteData.sublistView(arr);

  view.setUint32(0, number, Endian.big); // byteOffset = 0; litteEndian = false

  return arr.toList();
}

bool isURType(String type) {
  return type.split('').every((item) {
    var c = item.codeUnitAt(0);

    if ('a'.codeUnitAt(0) <= c && c <= 'z'.codeUnitAt(0)) return true;
    if ('0'.codeUnitAt(0) <= c && c <= '9'.codeUnitAt(0)) return true;
    if (c == '-'.codeUnitAt(0)) return true;
    return false;
  });
}

// export 'utils'const hasPrefix = (s: string, prefix: string): boolean => s.indexOf(prefix) === 0;

// export 'utils'const arraysEqual = (ar1: any[], ar2: any[]): boolean => {
//   if (ar1.length !== ar2.length) {
//     return false;
//   }

//   return ar1.every(el => ar2.includes(el))
// }

// /**
//  * Checks if ar1 contains all elements of ar2
//  * @param ar1 the outer array
//  * @param ar2 the array to be contained in ar1
//  */
// export 'utils'const arrayContains = (ar1: any[], ar2: any[]): boolean => {
//   return ar2.every(v => ar1.includes(v))
// }

// /**
//  * Returns the difference array of  `ar1` - `ar2`
//  */
// export 'utils'const setDifference = (ar1: any[], ar2: any[]): any[] => {
//   return ar1.filter(x => ar2.indexOf(x) < 0)
// }

// export 'utils'const bufferXOR = (a: Buffer, b: Buffer): Buffer => {
//   const length = Math.max(a.length, b.length);
//   const buffer = Buffer.allocUnsafe(length);

//   for (let i = 0; i < length; ++i) {
//     buffer[i] = a[i] ^ b[i];
//   }

//   return buffer;
// }
x(RegExpMatch e) {}
