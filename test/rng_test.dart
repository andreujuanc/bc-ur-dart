import 'package:bc_ur/src/jsport.dart';
import 'package:bc_ur/src/utils.dart';
import 'package:bc_ur/src/xoshiro.dart';
import 'package:decimal/decimal.dart';
import 'package:test/test.dart';

// import FountainEncoder from "../src/fountainEncoder";
// import { chooseDegree, chooseFragments, shuffle } from "../src/fountainUtils";
// import { bufferXOR, getCRC, intToBytes } from "../src/utils";
// import Xoshiro from "../src/xoshiro";
// import { makeMessage } from "./utils";
// var randomSampler = require('@apocentre/alias-sampling');

void main() {
  group('Xoshiro', () {
    test('1', () {
      var rng = Xoshiro(Buffer.from('Wolf', "utf-8"));

      var numbers = List<int>.generate(100, (index) => (rng.next() % Decimal.fromInt(100)).toBigInt().toInt());

      var expectedNumbers = [
        42,
        81,
        85,
        8,
        82,
        84,
        76,
        73,
        70,
        88,
        2,
        74,
        40,
        48,
        77,
        54,
        88,
        7,
        5,
        88,
        37,
        25,
        82,
        13,
        69,
        59,
        30,
        39,
        11,
        82,
        19,
        99,
        45,
        87,
        30,
        15,
        32,
        22,
        89,
        44,
        92,
        77,
        29,
        78,
        4,
        92,
        44,
        68,
        92,
        69,
        1,
        42,
        89,
        50,
        37,
        84,
        63,
        34,
        32,
        3,
        17,
        62,
        40,
        98,
        82,
        89,
        24,
        43,
        85,
        39,
        15,
        3,
        99,
        29,
        20,
        42,
        27,
        10,
        85,
        66,
        50,
        35,
        69,
        70,
        70,
        74,
        30,
        13,
        72,
        54,
        11,
        5,
        70,
        55,
        91,
        52,
        10,
        43,
        43,
        52
      ];

      expect(numbers, expectedNumbers);
    });

    test('2', () {
      var checksum = intToBytes(getCRC(Buffer.from('Wolf', "utf-8")).toInt());
      var rng = Xoshiro(checksum);
      var numbers = List<int>.generate(100, (index) => (rng.next() % Decimal.fromInt(100)).toBigInt().toInt());
      var expectedNumbers = [
        88,
        44,
        94,
        74,
        0,
        99,
        7,
        77,
        68,
        35,
        47,
        78,
        19,
        21,
        50,
        15,
        42,
        36,
        91,
        11,
        85,
        39,
        64,
        22,
        57,
        11,
        25,
        12,
        1,
        91,
        17,
        75,
        29,
        47,
        88,
        11,
        68,
        58,
        27,
        65,
        21,
        54,
        47,
        54,
        73,
        83,
        23,
        58,
        75,
        27,
        26,
        15,
        60,
        36,
        30,
        21,
        55,
        57,
        77,
        76,
        75,
        47,
        53,
        76,
        9,
        91,
        14,
        69,
        3,
        95,
        11,
        73,
        20,
        99,
        68,
        61,
        3,
        98,
        36,
        98,
        56,
        65,
        14,
        80,
        74,
        57,
        63,
        68,
        51,
        56,
        24,
        39,
        53,
        80,
        57,
        51,
        81,
        3,
        1,
        30
      ];

      expect(numbers, expectedNumbers);
    });

    test('3', () {
      var rng = Xoshiro(Buffer.from('Wolf', "utf-8"));
      var numbers = List<int>.generate(100, (index) => rng.nextInt(1, 10));
      var expectedNumbers = [6, 5, 8, 4, 10, 5, 7, 10, 4, 9, 10, 9, 7, 7, 1, 1, 2, 9, 9, 2, 6, 4, 5, 7, 8, 5, 4, 2, 3, 8, 7, 4, 5, 1, 10, 9, 3, 10, 2, 6, 8, 5, 7, 9, 3, 1, 5, 2, 7, 1, 4, 4, 4, 4, 9, 4, 5, 5, 6, 9, 5, 1, 2, 8, 3, 3, 2, 8, 4, 3, 2, 1, 10, 8, 9, 3, 10, 8, 5, 5, 6, 7, 10, 5, 8, 9, 4, 6, 4, 2, 10, 2, 1, 7, 9, 6, 7, 4, 2, 5];

      expect(numbers, expectedNumbers);
    });
  });

// describe('Shuffle', () {
//   test('random shuffle', () {
//     var rng = Xoshiro(Buffer.from('Wolf', "utf-8"));
//     var values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

//     var result = [...new Array(10)].map(() => shuffle(values, rng))
//     var expectedResult = [
//       [6, 4, 9, 3, 10, 5, 7, 8, 1, 2],
//       [10, 8, 6, 5, 1, 2, 3, 9, 7, 4],
//       [6, 4, 5, 8, 9, 3, 2, 1, 7, 10],
//       [7, 3, 5, 1, 10, 9, 4, 8, 2, 6],
//       [8, 5, 7, 10, 2, 1, 4, 3, 9, 6],
//       [4, 3, 5, 6, 10, 2, 7, 8, 9, 1],
//       [5, 1, 3, 9, 4, 6, 2, 10, 7, 8],
//       [2, 1, 10, 8, 9, 4, 7, 6, 3, 5],
//       [6, 7, 10, 4, 8, 9, 2, 3, 1, 5],
//       [10, 2, 1, 7, 9, 5, 6, 3, 4, 8]
//     ]

//     expect(result).toEqual(expectedResult);
//   });
// });

// describe('Random Sampler', () {
//   test('random sampler', () {
//     var rng = Xoshiro(Buffer.from('Wolf', "utf-8"));
//     var sampler = randomSampler([1, 2, 4, 8], null, rng.nextDouble);

//     var samples = [...new Array(500)].map(() => sampler.next())
//     var expectedSamples = [3, 3, 3, 3, 3, 3, 3, 0, 2, 3, 3, 3, 3, 1, 2, 2, 1, 3, 3, 2, 3, 3, 1, 1, 2, 1, 1, 3, 1, 3, 1, 2, 0, 2, 1, 0, 3, 3, 3, 1, 3, 3, 3, 3, 1, 3, 2, 3, 2, 2, 3, 3, 3, 3, 2, 3, 3, 0, 3, 3, 3, 3, 1, 2, 3, 3, 2, 2, 2, 1, 2, 2, 1, 2, 3, 1, 3, 0, 3, 2, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 1, 3, 3, 2, 0, 2, 2, 3, 1, 1, 2, 3, 2, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 2, 3, 1, 2, 1, 1, 3, 1, 3, 2, 2, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 2, 3, 3, 1, 2, 3, 3, 1, 3, 2, 3, 3, 3, 2, 3, 1, 3, 0, 3, 2, 1, 1, 3, 1, 3, 2, 3, 3, 3, 3, 2, 0, 3, 3, 1, 3, 0, 2, 1, 3, 3, 1, 1, 3, 1, 2, 3, 3, 3, 0, 2, 3, 2, 0, 1, 3, 3, 3, 2, 2, 2, 3, 3, 3, 3, 3, 2, 3, 3, 3, 3, 2, 3, 3, 2, 0, 2, 3, 3, 3, 3, 2, 1, 1, 1, 2, 1, 3, 3, 3, 2, 2, 3, 3, 1, 2, 3, 0, 3, 2, 3, 3, 3, 3, 0, 2, 2, 3, 2, 2, 3, 3, 3, 3, 1, 3, 2, 3, 3, 3, 3, 3, 2, 2, 3, 1, 3, 0, 2, 1, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 2, 2, 2, 3, 1, 1, 3, 2, 2, 0, 3, 2, 1, 2, 1, 0, 3, 3, 3, 2, 2, 3, 2, 1, 2, 0, 0, 3, 3, 2, 3, 3, 2, 3, 3, 3, 3, 3, 2, 2, 2, 3, 3, 3, 3, 3, 1, 1, 3, 2, 2, 3, 1, 1, 0, 1, 3, 2, 3, 3, 2, 3, 3, 2, 3, 3, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 1, 2, 3, 3, 2, 2, 2, 2, 3, 3, 2, 0, 2, 1, 3, 3, 3, 3, 0, 3, 3, 3, 3, 2, 2, 3, 1, 3, 3, 3, 2, 3, 3, 3, 2, 3, 3, 3, 3, 2, 3, 2, 1, 3, 3, 3, 3, 2, 2, 0, 1, 2, 3, 2, 0, 3, 3, 3, 3, 3, 3, 1, 3, 3, 2, 3, 2, 2, 3, 3, 3, 3, 3, 2, 2, 3, 3, 2, 2, 2, 1, 3, 3, 3, 3, 1, 2, 3, 2, 3, 3, 2, 3, 2, 3, 3, 3, 2, 3, 1, 2, 3, 2, 1, 1, 3, 3, 2, 3, 3, 2, 3, 3, 0, 0, 1, 3, 3, 2, 3, 3, 3, 3, 1, 3, 3, 0, 3, 2, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 0, 3, 3, 2]

//     expect(samples).toEqual(expectedSamples);
//   });
// });

// describe('Degree', () {
//   test('choose degree', () {
//     var message = makeMessage(1024);
//     var fragmentLength = FountainEncoder.findNominalFragmentLength(message.length, 10, 100);
//     var fragments = FountainEncoder.partitionMessage(message, fragmentLength);

//     var degrees = [...new Array(200)].map((_, index) => {
//       var rng = Xoshiro(Buffer.from(`Wolf-${index + 1}`))
//       return chooseDegree(fragments.length, rng);
//     })
//     var expectedDegrees = [11, 3, 6, 5, 2, 1, 2, 11, 1, 3, 9, 10, 10, 4, 2, 1, 1, 2, 1, 1, 5, 2, 4, 10, 3, 2, 1, 1, 3, 11, 2, 6, 2, 9, 9, 2, 6, 7, 2, 5, 2, 4, 3, 1, 6, 11, 2, 11, 3, 1, 6, 3, 1, 4, 5, 3, 6, 1, 1, 3, 1, 2, 2, 1, 4, 5, 1, 1, 9, 1, 1, 6, 4, 1, 5, 1, 2, 2, 3, 1, 1, 5, 2, 6, 1, 7, 11, 1, 8, 1, 5, 1, 1, 2, 2, 6, 4, 10, 1, 2, 5, 5, 5, 1, 1, 4, 1, 1, 1, 3, 5, 5, 5, 1, 4, 3, 3, 5, 1, 11, 3, 2, 8, 1, 2, 1, 1, 4, 5, 2, 1, 1, 1, 5, 6, 11, 10, 7, 4, 7, 1, 5, 3, 1, 1, 9, 1, 2, 5, 5, 2, 2, 3, 10, 1, 3, 2, 3, 3, 1, 1, 2, 1, 3, 2, 2, 1, 3, 8, 4, 1, 11, 6, 3, 1, 1, 1, 1, 1, 3, 1, 2, 1, 10, 1, 1, 8, 2, 7, 1, 2, 1, 9, 2, 10, 2, 1, 3, 4, 10]

//     expect(degrees).toEqual(expectedDegrees);
//   });
// });

// describe('Fragments', () {
//   test('choose fragments', () {
//     var message = makeMessage(1024);
//     var checksum = getCRC(message);
//     var fragmentLength = FountainEncoder.findNominalFragmentLength(message.length, 10, 100);
//     var fragments = FountainEncoder.partitionMessage(message, fragmentLength);

//     var fragmentIndexes = [...new Array(30)].map((_, index) => {
//       return chooseFragments(index + 1, fragments.length, checksum)
//         .sort((a, b) => a - b);
//     })
//     var expectedDegrees = [
//       [0],
//       [1],
//       [2],
//       [3],
//       [4],
//       [5],
//       [6],
//       [7],
//       [8],
//       [9],
//       [10],
//       [9],
//       [2, 5, 6, 8, 9, 10],
//       [8],
//       [1, 5],
//       [1],
//       [0, 2, 4, 5, 8, 10],
//       [5],
//       [2],
//       [2],
//       [0, 1, 3, 4, 5, 7, 9, 10],
//       [0, 1, 2, 3, 5, 6, 8, 9, 10],
//       [0, 2, 4, 5, 7, 8, 9, 10],
//       [3, 5],
//       [4],
//       [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
//       [0, 1, 3, 4, 5, 6, 7, 9, 10],
//       [6],
//       [5, 6],
//       [7]
//     ]

//     expect(fragmentIndexes).toEqual(expectedDegrees);
//   });
// });

// describe('XOR', () {
//   test('test xor', () {
//     var rng = Xoshiro(Buffer.from('Wolf', "utf-8"))
//     var data1 = Buffer.from(rng.nextData(10));

//     expect(data1.toString('hex')).toEqual('916ec65cf77cadf55cd7')

//     var data2 = Buffer.from(rng.nextData(10));

//     expect(data2.toString('hex')).toEqual('f9cda1a1030026ddd42e')
//     let data3 = Buffer.alloc(data1.length);

//     data1.copy(data3);
//     data3 = bufferXOR(data3, data2)

//     expect(data3.toString('hex')).toEqual('68a367fdf47c8b2888f9')

//     data3 = bufferXOR(data3, data1);

//     expect(data3.equals(data2)).toBe(true)
//   });
// });
}
