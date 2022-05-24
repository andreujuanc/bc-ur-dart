import 'package:bc_ur/src/utils.dart';
import 'package:decimal/decimal.dart';

// import { sha256Hash } from "./utils";
// import BigNumber from 'bignumber.js'
// import JSBI from 'jsbi'

// const MAX_UINT64 = 0xFFFFFFFFFFFFFFFF;
BigInt _rotl(BigInt x, int k) => ((x << k).toUnsigned(64) ^
    //JSBI.signedRightShift(x, BigInt.from(64) - BigInt.from(k)).toUnsigned(64)
    (x >> 64 - k).toUnsigned(64));

class Xoshiro {
  late List<BigInt> s;

  Xoshiro(List<int> seed) {
    var digest = sha256Hash(seed);

    s = [BigInt.zero, BigInt.zero, BigInt.zero, BigInt.zero];
    _setS(digest);
  }

  _setS(List<int> digest) {
    for (var i = 0; i < 4; i++) {
      var o = i * 8;
      var v = BigInt.zero;
      for (var n = 0; n < 8; n++) {
        // TODO: Cleanup and refactor as original
        v = (v << 8).toUnsigned(64);
        var d = BigInt.from(digest[o + n]);
        var or = (v | d);
        v = or.toUnsigned(64);
        //v = JSBI.asUintN(64, JSBI.leftShift(v, JSBI.BigInt(8)));
        //v = JSBI.asUintN(64, JSBI.bitwiseOr(v, JSBI.BigInt(digest[o + n])));
      }
      s[i] = v.toUnsigned(64);
    }
  }

  BigInt _roll() {

    var r = _rotl((s[1] * BigInt.from(5)).toUnsigned(64), 7);
    var result = (r * BigInt.from(9)).toUnsigned(64);

    var t = (s[1] << 17).toUnsigned(64);

    s[2] = (s[2] ^ s[0]).toUnsigned(64);
    s[3] = (s[3] ^ s[1]).toUnsigned(64);
    s[1] = (s[1] ^ s[2]).toUnsigned(64);
    s[0] = (s[0] ^ s[3]).toUnsigned(64);

    s[2] = (s[2] ^ t).toUnsigned(64);

    s[3] = _rotl(s[3], 45).toUnsigned(64);

    return result;
  }

  Decimal next() {
    return Decimal.parse(_roll().toString());
  }

  // nextDouble = (): BigNumber => {
  //   return new BigNumber(this.roll().toString()).div(MAX_UINT64 + 1)
  // }

  // nextInt = (low: number, high: number): number => {
  //   return Math.floor((this.nextDouble().toNumber() * (high - low + 1)) + low);
  // }

  // nextByte = () => this.nextInt(0, 255);

  // nextData = (count: number) => (
  //   [...new Array(count)].map(() => this.nextByte())
  // )
}
