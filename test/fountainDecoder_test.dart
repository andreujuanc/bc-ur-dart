// import FountainEncoder from "../src/fountainEncoder";
// import FountainDecoder from "../src/fountainDecoder";
// import { makeMessage } from "./utils";
import 'package:bc_ur/src/fountainDecoder.dart';
import 'package:bc_ur/src/fountainEncoder.dart';
import 'package:bc_ur/src/jsport.dart';
import 'package:bc_ur/src/utils.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {

group('Fountain Decoder', ()  {
  test('decoder', () {
    // var message = makeMessage(32767, null);
    // var maxFragmentLength = 1000;
    // var encoder = FountainEncoder(message, maxFragmentLength: maxFragmentLength, firstSeqNum: 100);
    // var decoder = FountainDecoder();

    // do {
    //   var part = encoder.nextPart();
    //   decoder.receivePart(part);
    // } while (!decoder.isComplete())

    // if (decoder.isSuccess()) {
    //   expect(decoder.resultMessage().equals(message)).toBe(true);
    // }
    // else {
    //   print('decoder.resultError() ${decoder.resultError()}');
    //   expect(true, false);
    // }

  });
  // test('partition and join', ()  {
  //   var message = makeMessage(1024, null);
  //   var fragmentLength = FountainEncoder.findNominalFragmentLength(message.length, 10, 100);
  //   var fragments = FountainEncoder.partitionMessage(message, fragmentLength);

  //   var fragmentsHex = fragments.map(fragment => fragment.toString('hex'));

  //   var expectedFragmentHexes = [
  //     "916ec65cf77cadf55cd7f9cda1a1030026ddd42e905b77adc36e4f2d3ccba44f7f04f2de44f42d84c374a0e149136f25b01852545961d55f7f7a8cde6d0e2ec43f3b2dcb644a2209e8c9e34af5c4747984a5e873c9cf5f965e25ee29039f",
  //     "df8ca74f1c769fc07eb7ebaec46e0695aea6cbd60b3ec4bbff1b9ffe8a9e7240129377b9d3711ed38d412fbb4442256f1e6f595e0fc57fed451fb0a0101fb76b1fb1e1b88cfdfdaa946294a47de8fff173f021c0e6f65b05c0a494e50791",
  //     "270a0050a73ae69b6725505a2ec8a5791457c9876dd34aadd192a53aa0dc66b556c0c215c7ceb8248b717c22951e65305b56a3706e3e86eb01c803bbf915d80edcd64d4d41977fa6f78dc07eecd072aae5bc8a852397e06034dba6a0b570",
  //     "797c3a89b16673c94838d884923b8186ee2db5c98407cab15e13678d072b43e406ad49477c2e45e85e52ca82a94f6df7bbbe7afbed3a3a830029f29090f25217e48d1f42993a640a67916aa7480177354cc7440215ae41e4d02eae9a1912",
  //     "33a6d4922a792c1b7244aa879fefdb4628dc8b0923568869a983b8c661ffab9b2ed2c149e38d41fba090b94155adbed32f8b18142ff0d7de4eeef2b04adf26f2456b46775c6c20b37602df7da179e2332feba8329bbb8d727a138b4ba7a5",
  //     "03215eda2ef1e953d89383a382c11d3f2cad37a4ee59a91236a3e56dcf89f6ac81dd4159989c317bd649d9cbc617f73fe10033bd288c60977481a09b343d3f676070e67da757b86de27bfca74392bac2996f7822a7d8f71a489ec6180390",
  //     "089ea80a8fcd6526413ec6c9a339115f111d78ef21d456660aa85f790910ffa2dc58d6a5b93705caef1091474938bd312427021ad1eeafbd19e0d916ddb111fabd8dcab5ad6a6ec3a9c6973809580cb2c164e26686b5b98cfb017a337968",
  //     "c7daaa14ae5152a067277b1b3902677d979f8e39cc2aafb3bc06fcf69160a853e6869dcc09a11b5009f91e6b89e5b927ab1527a735660faa6012b420dd926d940d742be6a64fb01cdc0cff9faa323f02ba41436871a0eab851e7f5782d10",
  //     "fbefde2a7e9ae9dc1e5c2c48f74f6c824ce9ef3c89f68800d44587bedc4ab417cfb3e7447d90e1e417e6e05d30e87239d3a5d1d45993d4461e60a0192831640aa32dedde185a371ded2ae15f8a93dba8809482ce49225daadfbb0fec629e",
  //     "23880789bdf9ed73be57fa84d555134630e8d0f7df48349f29869a477c13ccca9cd555ac42ad7f568416c3d61959d0ed568b2b81c7771e9088ad7fd55fd4386bafbf5a528c30f107139249357368ffa980de2c76ddd9ce4191376be0e6b5",
  //     "170010067e2e75ebe2d2904aeb1f89d5dc98cd4a6f2faaa8be6d03354c990fd895a97feb54668473e9d942bb99e196d897e8f1b01625cf48a7b78d249bb4985c065aa8cd1402ed2ba1b6f908f63dcd84b66425df00000000000000000000"
  //   ]

  //   expect(fragmentsHex).toEqual(expectedFragmentHexes);

  //   var rejoinedMessage = FountainDecoder.joinFragments(fragments, message.length);
  //   expect(message).toEqual(rejoinedMessage);

  // });



});
}