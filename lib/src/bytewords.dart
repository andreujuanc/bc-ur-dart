import 'dart:convert';
import 'dart:typed_data';
import 'package:bc_ur/src/utils.dart';
import 'package:convert/convert.dart';

enum BYTEWORD_STYLES {
  STANDARD, //= 'standard',
  URI, // = 'uri',
  MINIMAL //= 'minimal'
}

const _bytewords =
    'ableacidalsoapexaquaarchatomauntawayaxisbackbaldbarnbeltbetabiasbluebodybragbrewbulbbuzzcalmcashcatschefcityclawcodecolacookcostcruxcurlcuspcyandarkdatadaysdelidicedietdoordowndrawdropdrumdulldutyeacheasyechoedgeepicevenexamexiteyesfactfairfernfigsfilmfishfizzflapflewfluxfoxyfreefrogfuelfundgalagamegeargemsgiftgirlglowgoodgraygrimgurugushgyrohalfhanghardhawkheathelphighhillholyhopehornhutsicedideaidleinchinkyintoirisironitemjadejazzjoinjoltjowljudojugsjumpjunkjurykeepkenokeptkeyskickkilnkingkitekiwiknoblamblavalazyleaflegsliarlimplionlistlogoloudloveluaulucklungmainmanymathmazememomenumeowmildmintmissmonknailnavyneednewsnextnoonnotenumbobeyoboeomitonyxopenovalowlspaidpartpeckplaypluspoempoolposepuffpumapurrquadquizraceramprealredorichroadrockroofrubyruinrunsrustsafesagascarsetssilkskewslotsoapsolosongstubsurfswantacotasktaxitenttiedtimetinytoiltombtoystriptunatwinuglyundouniturgeuservastveryvetovialvibeviewvisavoidvowswallwandwarmwaspwavewaxywebswhatwhenwhizwolfworkyankyawnyellyogayurtzapszerozestzinczonezoom';
var _bytewordsLookUpTable = List<int>.empty();
const _BYTEWORDS_NUM = 256;
const _BYTEWORD_LENGTH = 4;
const _MINIMAL_BYTEWORD_LENGTH = 2;

class Bytewords {
  static String getWord(int index) {
    return _bytewords.substring(
        index * _BYTEWORD_LENGTH, (index * _BYTEWORD_LENGTH) + _BYTEWORD_LENGTH);
  }

  static String getMinimalWord(int index) {
    var byteword = getWord(index);

    return "${byteword[0]}${byteword[_BYTEWORD_LENGTH - 1]}";
  }

  static String addCRC(String string) {
    var crc = getCRCHex(hex.decode(string));
    return "$string$crc";
  }

  static String encodeWithSeparator(String word, String separator) {
    var crcAppendedWord = addCRC(word);
    var crcWordBuff = hex.decode(crcAppendedWord);

    var result =
        crcWordBuff.fold<List<String>>([], (List<String> result, int word) {
      return [...result, getWord(word)];
    });

    return result.join(separator);
  }

  static String encodeMinimal(String word) {
    var crcAppendedWord = addCRC(word);
    var crcWordBuff = hex.decode(crcAppendedWord);

    var result = crcWordBuff.fold<String>('', (String result, int word) {
      return result + getMinimalWord(word);
    });
    return result;
  }

  static String decodeWord(String word, int wordLength) {
    assert(word.length == wordLength,
        'Invalid Bytewords: word.length does not match wordLength provided');

    const dim = 26;

//   // Since the first and last letters of each Byteword are unique,
//   // we can use them as indexes into a two-dimensional lookup table.
//   // This table is generated lazily.
    if (_bytewordsLookUpTable.length == 0) {
      const array_len = dim * dim;
      _bytewordsLookUpTable = [
        ...List<int>.filled(array_len, -1)
      ]; //.map(() => -1);

      for (var i = 0; i < _BYTEWORDS_NUM; i++) {
        var byteword = getWord(i);
        var x = byteword[0].codeUnitAt(0) -
            'a'.codeUnitAt(0); //.charCodeAt(0) - 'a'.charCodeAt(0);
        var y = byteword[3].codeUnitAt(0) -
            'a'.codeUnitAt(0); //.charCodeAt(0) - 'a'.charCodeAt(0);
        var offset = y * dim + x;
        _bytewordsLookUpTable[offset] = i;
      }
    }

//   // If the coordinates generated by the first and last letters are out of bounds,
//   // or the lookup table contains -1 at the coordinates, then the word is not valid.
    var x = (word[0]).toLowerCase().codeUnitAt(0) - 'a'.codeUnitAt(0);
    var y = (word[wordLength == 4 ? 3 : 1]).toLowerCase().codeUnitAt(0) -
        'a'.codeUnitAt(0);

    assert(0 <= x && x < dim && 0 <= y && y < dim,
        'Invalid Bytewords: invalid word');

    var offset = y * dim + x;
    var value = _bytewordsLookUpTable[offset];

    assert(value != -1, 'Invalid Bytewords: value not in lookup table');

//   // If we're decoding a full four-letter word, verify that the two middle letters are correct.
    if (wordLength == _BYTEWORD_LENGTH) {
      var byteword = getWord(value);
      var c1 = word[1].toLowerCase();
      var c2 = word[2].toLowerCase();

      assert(c1 == byteword[1] && c2 == byteword[2],
          'Invalid Bytewords: invalid middle letters of word');
    }

//   // Successful decode.
    //return Buffer.from([value]).toString('hex')
    return hex.encode([value]);
  }

  static String _decode(String string, String separator, int wordLength) {
    var words = wordLength == _BYTEWORD_LENGTH
        ? string.split(separator)
        : partition(string, 2);
    var decodedString =
        words.map((String word) => decodeWord(word, wordLength)).join('');

    assert(decodedString.length >= 5,
        'Invalid Bytewords: invalid decoded string length');

    //var [body, bodyChecksum] = split(Buffer.from(decodedString, 'hex'), 4)
    var splitResult = split(hex.decode(decodedString), 4);
    var body = splitResult[0];
    var bodyChecksum = splitResult[1];

    var checksum = getCRCHex(body); // convert to hex

    assert(checksum == hex.encode(bodyChecksum), 'Invalid Checksum');

    return hex.encode(body);
  }

  static String decode(String string, BYTEWORD_STYLES style) {
    switch (style) {
      case BYTEWORD_STYLES.STANDARD:
        return _decode(string, ' ', _BYTEWORD_LENGTH);
      case BYTEWORD_STYLES.URI:
        return _decode(string, '-', _BYTEWORD_LENGTH);
      case BYTEWORD_STYLES.MINIMAL:
        return _decode(string, '', _MINIMAL_BYTEWORD_LENGTH);
      default:
        throw "Invalid style $style";
    }
  }

  static String encode(String string, BYTEWORD_STYLES style) {
    switch (style) {
      case BYTEWORD_STYLES.STANDARD:
        return encodeWithSeparator(string, ' ');
      case BYTEWORD_STYLES.URI:
        return encodeWithSeparator(string, '-');
      case BYTEWORD_STYLES.MINIMAL:
        return encodeMinimal(string);
      default:
        throw "Invalid style $style";
    }
  }
}
