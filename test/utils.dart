import 'package:bc_ur/src/cbor.dart';
import 'package:bc_ur/src/jsport.dart';
import 'package:bc_ur/src/ur.dart';
import 'package:xrandom/xrandom.dart';

// import UR from "../src/ur";
// import Xoshiro from "../src/xoshiro";
// import { cborEncode } from '../src/cbor';

List<int> makeMessage(int length, String? seed) {
  seed ??= 'Wolf';
  int data = int.parse(Buffer.from(seed, 'utf-8').toHexString(), radix: 16);
  var rng = Xrandom(data);

  return List.generate(length, (index) => rng.nextInt(length));
}

UR makeMessageUR(int length, String? seed) {
  seed ??= 'Wolf';

  var message = makeMessage(length, seed);

  var cborMessage = cborEncode(message);

  return UR(cborMessage, null);
}
