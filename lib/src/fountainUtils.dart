import 'package:bc_ur/src/sampling.dart';
import 'package:bc_ur/src/utils.dart';
import 'package:bc_ur/src/xoshiro.dart';

int chooseDegree(int seqLenth, Xoshiro rng) {
  final degreeProbabilities = List<double>.generate(
      seqLenth, (index) => 1 / (index + 1)); //[...new Array(seqLenth)].map((_, index) => 1 / (index + 1));
  final degreeChooser = Sample(degreeProbabilities, null, rng.nextDouble);

  return degreeChooser.next(null) + 1;
}

List<T> shuffle<T>(List items, Xoshiro rng) {
  final List<T> remaining = [...items];
  final List<T> result = [];

  while (remaining.isNotEmpty) {
    final index = rng.nextInt(0, remaining.length - 1);
    final item = remaining[index];
    // remaining.erase(remaining.begin() + index);
    remaining.removeRange(index, 1); //remaining.splice(index, 1);
    result.add(item);
  }

  return result;
}

List<int> chooseFragments(int seqNum, int seqLength, int checksum) {
  // The first `seqLenth` parts are the "pure" fragments, not mixed with any
  // others. This means that if you only generate the first `seqLenth` parts,
  // then you have all the parts you need to decode the message.
  if (seqNum <= seqLength) {
    return [seqNum - 1];
  } else {
    var seed = [...intToBytes(seqNum), ...intToBytes(checksum)];
    var rng = Xoshiro(seed);
    var degree = chooseDegree(seqLength, rng);
    var indexes = List<int>.generate(seqLength, (index) => index);
    var shuffledIndexes = shuffle<int>(indexes, rng);

    return shuffledIndexes.sublist(0, degree);
  }
}
