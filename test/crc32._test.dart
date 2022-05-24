import 'package:bc_ur/src/jsport.dart';
import 'package:bc_ur/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('CRC32', () {
    test('crc32 results', () {
      expect(getCRCHex(Buffer.from('Hello, world!', 'utf-8')), 'ebe6c6e6');
      expect(getCRCHex(Buffer.from('Wolf', 'utf-8')), '598c84dc');
      expect(getCRCHex(Buffer.from('d9012ca20150c7098580125e2ab0981253468b2dbc5202d8641947da', 'hex')), 'd22c52b6');
    });
  });
}
