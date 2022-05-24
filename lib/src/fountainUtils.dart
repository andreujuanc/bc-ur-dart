// import { intToBytes } from "./utils";
// import Xoshiro from "./xoshiro";
// const randomSampler = require('@apocentre/alias-sampling');

// export const chooseDegree = (seqLenth: number, rng: Xoshiro): number => {
//   const degreeProbabilities = [...new Array(seqLenth)].map((_, index) => 1 / (index + 1));
//   const degreeChooser = randomSampler(degreeProbabilities, null, rng.nextDouble);

//   return degreeChooser.next() + 1;
// }

// export const shuffle = (items: any[], rng: Xoshiro): any[] => {
//   let remaining = [...items];
//   let result = [];

//   while (remaining.length > 0) {
//     let index = rng.nextInt(0, remaining.length - 1);
//     let item = remaining[index];
//     // remaining.erase(remaining.begin() + index);
//     remaining.splice(index, 1);
//     result.push(item);
//   }

//   return result;
// }

// List<int> chooseFragments(int seqNum, int seqLength, int checksum) {
//   // The first `seqLenth` parts are the "pure" fragments, not mixed with any
//   // others. This means that if you only generate the first `seqLenth` parts,
//   // then you have all the parts you need to decode the message.
//   if (seqNum <= seqLength) {
//     return [seqNum - 1];
//   } else {
//     var seed = Buffer.concat([intToBytes(seqNum), intToBytes(checksum)]);
//     var rng = new Xoshiro(seed);
//     var degree = chooseDegree(seqLength, rng);
//     var indexes = [...new Array(seqLength)].map((_, index) => index);
//     var shuffledIndexes = shuffle(indexes, rng);

//     return shuffledIndexes.slice(0, degree);
//   }
// }
