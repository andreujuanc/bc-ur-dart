/* global module */

import 'dart:math';

/// Library for sampling of random values from a discrete probability distribution,
/// using the Walker-Vose alias method.
///
/// Creates a new Sample instance for the given probabilities and outcomes.
///
/// @param {Array} the probabilities.
/// @param {Array} the outcomes. Index is assumed as outcome if not provided.
class Sample {
  List alias = [];
  List prob = [];
  List outcomes = [];
  late final double Function() rng;

  Sample(List<double> probabilities, List? outcomes, Function? rng) {
    outcomes ??= indexedOutcomes(probabilities.length);
    rng ??= Random().nextDouble;
    precomputeAlias(probabilities);
  }

  indexedOutcomes(int n) {
    var o = [];
    for (var i = 0; i < n; i++) {
      o[i] = i;
    }
    return o;
  }

// /**
//  * Ported from ransampl.c
//  * Scientific Computing Group of JCNS at MLZ Garching.
//  * http://apps.jcns.fz-juelich.de/doku/sc/ransampl
//  */

  precomputeAlias(List<double> p) {
    var n = p.length, sum = 0.0, nS = 0, nL = 0, P = [], S = [], L = [], g, i, a;

    // Normalize probabilities
    for (i = 0; i < n; ++i) {
      if (p[i] < 0) {
        throw 'Probability must be a positive: p[$i]=${p[i]}';
      }
      sum += p[i];
    }

    if (sum == 0) {
      throw 'Probability cannot be zero.';
    }

    for (i = 0; i < n; ++i) {
      P[i] = p[i] * n / sum;
    }

    // Set separate index lists for small and large probabilities:
    for (i = n - 1; i >= 0; --i) {
      // at variance from Schwarz, we revert the index order
      if (P[i] < 1) {
        S[nS++] = i;
      } else {
        L[nL++] = i;
      }
    }

    // Work through index lists
    //while (nS && nL) {
    while (nS > 0 && nL > 0) {
      a = S[--nS]; // Schwarz's l
      g = L[--nL]; // Schwarz's g

      prob[a] = P[a];
      alias[a] = g;

      P[g] = P[g] + P[a] - 1;
      if (P[g] < 1) {
        S[nS++] = g;
      } else {
        L[nL++] = g;
      }
    }

    while (nL > 0) {
      prob[L[--nL]] = 1;
    }

    while (nS > 0) {
      // can only happen through numeric instability
      prob[S[--nS]] = 1;
    }
  }

  /// 
  ///  Samples outcomes from the underlying probability distribution.
  /// 
  ///  @param {int} the number of samples. Optional parameter, defaults to 1.
  ///  @return {Object} a random outcome according to the underlying probability distribution 
  ///                   and the requested number of samples. If the requested number of samples 
  ///                   is greater than 1 this method returns an array.
  next(int? numOfSamples) {
    var n = numOfSamples ?? 1;
    var out = [], i = 0;

    do {
      var c = (rng() * prob.length).floor();
      out[i] = outcomes[(rng() < prob[c]) ? c : alias[c]];
    } while (++i < n);

    return (n > 1) ? out : out[0];
  }
}





// Sample.prototype.randomInt = function (min, max) {
//   'use strict';

//   return Math.floor(this.rng() * (max - min)) + min;
// };
