import 'package:bc_ur/src/jsport.dart';
import 'package:test/test.dart';
import 'package:bc_ur/src/bytewords.dart';

void main() {
  const hexInput = 'd9012ca20150c7098580125e2ab0981253468b2dbc5202d8641947da';
  const bufferInput = [
    245,
    215,
    20,
    198,
    241,
    235,
    69,
    59,
    209,
    205,
    165,
    18,
    150,
    158,
    116,
    135,
    229,
    212,
    19,
    159,
    17,
    37,
    239,
    240,
    253,
    11,
    109,
    191,
    37,
    242,
    38,
    120,
    223,
    41,
    156,
    189,
    242,
    254,
    147,
    204,
    66,
    163,
    216,
    175,
    191,
    72,
    169,
    54,
    32,
    60,
    144,
    230,
    210,
    137,
    184,
    197,
    33,
    113,
    88,
    14,
    157,
    31,
    177,
    46,
    1,
    115,
    205,
    69,
    225,
    150,
    65,
    235,
    58,
    144,
    65,
    240,
    133,
    69,
    113,
    247,
    63,
    53,
    242,
    165,
    160,
    144,
    26,
    13,
    79,
    237,
    133,
    71,
    82,
    69,
    254,
    165,
    138,
    41,
    85,
    24
  ];
  group("Bytewords", () {
    test('Bytewords:Encode:Standard', () {
      expect(Bytewords.encode(hexInput, BYTEWORD_STYLES.STANDARD),
          'tuna acid draw oboe acid good slot axis limp lava brag holy door puff monk brag guru frog luau drop roof grim also trip idle chef fuel twin tied draw grim ramp');
      expect(Bytewords.encode(bufferInput.toHexString(), BYTEWORD_STYLES.STANDARD),
          'yank toys bulb skew when warm free fair tent swan open brag mint noon jury list view tiny brew note body data webs what zinc bald join runs data whiz days keys user diet news ruby whiz zone menu surf flew omit trip pose runs fund part even crux fern math visa tied loud redo silk curl jugs hard beta next cost puma drum acid junk swan free very mint flap warm fact math flap what limp free jugs yell fish epic whiz open numb math city belt glow wave limp fuel grim free zone open love diet gyro cats fizz holy city puff');
    });
    test('Bytewords:Encode:URI', () {
      expect(Bytewords.encode(hexInput, BYTEWORD_STYLES.URI),
          'tuna-acid-draw-oboe-acid-good-slot-axis-limp-lava-brag-holy-door-puff-monk-brag-guru-frog-luau-drop-roof-grim-also-trip-idle-chef-fuel-twin-tied-draw-grim-ramp');
      expect(Bytewords.encode(bufferInput.toHexString(), BYTEWORD_STYLES.URI),
          'yank-toys-bulb-skew-when-warm-free-fair-tent-swan-open-brag-mint-noon-jury-list-view-tiny-brew-note-body-data-webs-what-zinc-bald-join-runs-data-whiz-days-keys-user-diet-news-ruby-whiz-zone-menu-surf-flew-omit-trip-pose-runs-fund-part-even-crux-fern-math-visa-tied-loud-redo-silk-curl-jugs-hard-beta-next-cost-puma-drum-acid-junk-swan-free-very-mint-flap-warm-fact-math-flap-what-limp-free-jugs-yell-fish-epic-whiz-open-numb-math-city-belt-glow-wave-limp-fuel-grim-free-zone-open-love-diet-gyro-cats-fizz-holy-city-puff');
    });
    test('Bytewords:Encode:Minimal', () {
      expect(Bytewords.encode(hexInput, BYTEWORD_STYLES.MINIMAL),
          'taaddwoeadgdstaslplabghydrpfmkbggufgludprfgmaotpiecffltntddwgmrp');
      expect(Bytewords.encode(bufferInput.toHexString(), BYTEWORD_STYLES.MINIMAL),
          'yktsbbswwnwmfefrttsnonbgmtnnjyltvwtybwnebydawswtzcbdjnrsdawzdsksurdtnsrywzzemusffwottppersfdptencxfnmhvatdldroskcljshdbantctpadmadjksnfevymtfpwmftmhfpwtlpfejsylfhecwzonnbmhcybtgwwelpflgmfezeonledtgocsfzhycypf');
    });
  });

  group("Bytewords", () {
    test('Bytewords:Decode:Standard', () {
      expect(
          Bytewords.decode(
              'tuna acid draw oboe acid good slot axis limp lava brag holy door puff monk brag guru frog luau drop roof grim also trip idle chef fuel twin tied draw grim ramp',
              BYTEWORD_STYLES.STANDARD),
          hexInput);

      expect(
          Bytewords.decode(
              'yank toys bulb skew when warm free fair tent swan open brag mint noon jury list view tiny brew note body data webs what zinc bald join runs data whiz days keys user diet news ruby whiz zone menu surf flew omit trip pose runs fund part even crux fern math visa tied loud redo silk curl jugs hard beta next cost puma drum acid junk swan free very mint flap warm fact math flap what limp free jugs yell fish epic whiz open numb math city belt glow wave limp fuel grim free zone open love diet gyro cats fizz holy city puff',
              BYTEWORD_STYLES.STANDARD),
          bufferInput.toHexString());
    });
    test('Bytewords:Decode:URI', () {
      expect(
          Bytewords.decode(
              'tuna-acid-draw-oboe-acid-good-slot-axis-limp-lava-brag-holy-door-puff-monk-brag-guru-frog-luau-drop-roof-grim-also-trip-idle-chef-fuel-twin-tied-draw-grim-ramp',
              BYTEWORD_STYLES.URI),
          hexInput);
      expect(
          Bytewords.decode(
              'yank-toys-bulb-skew-when-warm-free-fair-tent-swan-open-brag-mint-noon-jury-list-view-tiny-brew-note-body-data-webs-what-zinc-bald-join-runs-data-whiz-days-keys-user-diet-news-ruby-whiz-zone-menu-surf-flew-omit-trip-pose-runs-fund-part-even-crux-fern-math-visa-tied-loud-redo-silk-curl-jugs-hard-beta-next-cost-puma-drum-acid-junk-swan-free-very-mint-flap-warm-fact-math-flap-what-limp-free-jugs-yell-fish-epic-whiz-open-numb-math-city-belt-glow-wave-limp-fuel-grim-free-zone-open-love-diet-gyro-cats-fizz-holy-city-puff',
              BYTEWORD_STYLES.URI),
          bufferInput.toHexString());
    });
    test('Bytewords:Decode:Minimal', () {
      expect(
          Bytewords.decode('taaddwoeadgdstaslplabghydrpfmkbggufgludprfgmaotpiecffltntddwgmrp', BYTEWORD_STYLES.MINIMAL),
          hexInput);
      expect(
          Bytewords.decode(
              'yktsbbswwnwmfefrttsnonbgmtnnjyltvwtybwnebydawswtzcbdjnrsdawzdsksurdtnsrywzzemusffwottppersfdptencxfnmhvatdldroskcljshdbantctpadmadjksnfevymtfpwmftmhfpwtlpfejsylfhecwzonnbmhcybtgwwelpflgmfezeonledtgocsfzhycypf',
              BYTEWORD_STYLES.MINIMAL),
          bufferInput.toHexString());
    });

    test('Bytewords:Decode:Invalid checksums', () {
      //expect.assertions(3);
      expect(() => Bytewords.decode('able acid also lava zero jade need echo wolf', BYTEWORD_STYLES.STANDARD),
          throwsA(isA<AssertionError>()));

      expect(() => Bytewords.decode('able-acid-also-lava-zero-jade-need-echo-wolf', BYTEWORD_STYLES.URI),
          throwsA(isA<AssertionError>()));

      expect(() => Bytewords.decode('aeadaolazojendeowf', BYTEWORD_STYLES.MINIMAL), throwsA(isA<AssertionError>()));
    });

    test('Bytewords:Decode:Too short', () {
      //expect.assertions(2);

      expect(() => Bytewords.decode('wolf', BYTEWORD_STYLES.STANDARD), throwsA(isA<AssertionError>()));

      expect(() => Bytewords.decode('', BYTEWORD_STYLES.STANDARD), throwsA(isA<AssertionError>()));
    });
  });
}
