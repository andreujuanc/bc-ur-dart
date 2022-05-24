import 'package:bc_ur/src/cbor.dart';
import 'package:bc_ur/src/jsport.dart';
import 'package:bc_ur/src/ur.dart';
import 'package:bc_ur/src/xoshiro.dart';
import 'package:crypto/crypto.dart';
import 'package:xrandom/xrandom.dart';

// import UR from "../src/ur";
// import Xoshiro from "../src/xoshiro";
// import { cborEncode } from '../src/cbor';

// export const makeMessage = (length: number, seed: string = 'Wolf'): Buffer => {
//   const rng = new Xoshiro(Buffer.from(seed));

//   return Buffer.from(rng.nextData(length));
// }
  // next = (): BigNumber => {
  //   return new BigNumber(this.roll().toString())
  // }

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

List<int> makeMessage(int length, String? seed) {
  seed ??= 'Wolf';
  var seedData = sha256.convert(Buffer.from(seed, 'utf-8')).bytes;
  var rng = Xoshiro(seedData);

  return List.generate(length, (index) => rng.nextInt(0, 255));
}

UR makeMessageUR(int length, String? seed) {
  seed ??= 'Wolf';

  var message = makeMessage(length, seed);

  var cborMessage = cborEncode(message);

  return UR(cborMessage, null);
}
