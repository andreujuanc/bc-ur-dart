// import { sha256Hash } from "./utils";
// import BigNumber from 'bignumber.js'
// import JSBI from 'jsbi'

// const MAX_UINT64 = 0xFFFFFFFFFFFFFFFF;
// const rotl = (x: JSBI, k: number): JSBI => JSBI.bitwiseXor(
//   JSBI.asUintN(64, JSBI.leftShift(x, JSBI.BigInt(k))),
//   JSBI.BigInt(
//     JSBI.asUintN(
//       64,
//       JSBI.signedRightShift(x, (JSBI.subtract(JSBI.BigInt(64), JSBI.BigInt(k))))
//     )
//   )
// );

import 'package:bc_ur/src/utils.dart';
import 'package:decimal/decimal.dart';

class Xoshiro {
  late List<BigInt> s;

  Xoshiro(List<int> seed) {
    var digest = sha256Hash(seed);

    s = [BigInt.zero, BigInt.zero, BigInt.zero, BigInt.zero];
    _setS(digest);
    print(s);
  }

  _setS(List<int> digest) {
    for (var i = 0; i < 4; i++) {
      var o = i * 8;
      var v = BigInt.zero;
      for (var n = 0; n < 8; n++) {
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

  // private roll(): JSBI {
  //   const result = JSBI.asUintN(
  //     64,
  //     JSBI.multiply(
  //       rotl(
  //         JSBI.asUintN(64, JSBI.multiply(this.s[1], JSBI.BigInt(5))),
  //         7
  //       ),
  //       JSBI.BigInt(9)
  //     )
  //   );

  //   const t = JSBI.asUintN(64, JSBI.leftShift(this.s[1], JSBI.BigInt(17)));

  //   this.s[2] = JSBI.asUintN(64, JSBI.bitwiseXor(this.s[2], JSBI.BigInt(this.s[0])));
  //   this.s[3] = JSBI.asUintN(64, JSBI.bitwiseXor(this.s[3], JSBI.BigInt(this.s[1])));
  //   this.s[1] = JSBI.asUintN(64, JSBI.bitwiseXor(this.s[1], JSBI.BigInt(this.s[2])));
  //   this.s[0] = JSBI.asUintN(64, JSBI.bitwiseXor(this.s[0], JSBI.BigInt(this.s[3])));

  //   this.s[2] = JSBI.asUintN(64, JSBI.bitwiseXor(this.s[2], JSBI.BigInt(t)));

  //   this.s[3] = JSBI.asUintN(64, rotl(this.s[3], 45));

  //   return result;
  // }

  Decimal next() {
    return {} as dynamic; //Decimal.parse(this.roll().toString());
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
