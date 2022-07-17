import 'dart:convert';
import 'package:ephemeral/services/data_service.dart';

class CryptoUtils {

  List<String> alphabets = [];

  CryptoUtils() {
    init();
  }

  void init() {
    for(int i=65; i<=90; i++){
      alphabets.add(String.fromCharCode(i));
    }
  }

  Future<String> encode(String raw) async {
    var value = await loadAsset();

    var config = jsonDecode(value);
    var key = config["appKey"];

    // encode the key to base64
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encodedKey = stringToBase64.encode(key);

    // knowing that app id is a bigInt...
    num elevated = num.parse(raw) * 4;

    // then encode it to base64
    String encodedRawId = stringToBase64.encode(elevated.toString());
    print(encodedKey);
    print(encodedRawId);

    // extract every numbers from the encoded key and add it
    int total = 0;
    encodedKey.runes.forEach((int rune) {
      String char = new String.fromCharCode(rune);
      int? nb = int.tryParse(char);
      if(nb != null) {
        total += nb;
      }
    });
    
    List<int> rawIdNewVals = encodedRawId.runes.toList();

    // increase every 4 values from encodedRaw by the sum in asc order
    for(int i = 0; i < encodedRawId.runes.length; i+=4) {
      int rune = encodedRawId.runes.elementAt(i);
      String char = new String.fromCharCode(rune);
      int pos = alphabets.indexOf(char);
      int elevatedPos = pos + total;
      if(elevatedPos >= alphabets.length) {
        elevatedPos = alphabets.length - elevatedPos;
        elevatedPos = elevatedPos.abs();
      }
      String elevatedChar = alphabets[elevatedPos];
      rawIdNewVals[i] = elevatedChar.codeUnitAt(0);
    }

    String output = "";

    for (var element in rawIdNewVals) {
      output += new String.fromCharCode(element);
    }

    print(output);
    return output;
  }

}