import 'package:convert/convert.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test("MakeMessage", () {
    var result = makeMessage(10, 'Wolf');
    expect(result, hex.decode('91 6e c6 5c f7 7c ad f5 5c d7'.replaceAll(' ', '')));
    //91 6e c6 5c f7 7c ad f5 5c d7 f9 cd a1 a1 03 00 26 dd d4 2e 90 5b 77 ad c3 6e 4f 2d 3c cb a4 4f 7f 04 f2 de 44 f4 2d 84 c3 74 a0 e1 49 13 6f 25 b0 18
  });
}
