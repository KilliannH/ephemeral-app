import 'dart:convert';
import 'package:ephemeral/services/data_service.dart';
import 'package:flutter/cupertino.dart';

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

  /**
   * encode a bigint like String
   */
  Future<String> encode(String raw) async {
    print(raw);
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
      int elevatedPos = (pos + total) - alphabets.length;
      if(elevatedPos < 0) {
        elevatedPos = alphabets.length + elevatedPos;
      }
      String elevatedChar = alphabets[elevatedPos];
      rawIdNewVals[i] = elevatedChar.codeUnitAt(0);
    }

    String output = "";

    for (var element in rawIdNewVals) {
      output += new String.fromCharCode(element);
    }

    return output;
  }

  Future<String> decode(String encoded) async {
    var value = await loadAsset();

    var config = jsonDecode(value);
    var key = config["appKey"];

    // encode the key to base64
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encodedKey = stringToBase64.encode(key);

    // extract every numbers from the encoded key and add it
    int total = 0;
    encodedKey.runes.forEach((int rune) {
      String char = new String.fromCharCode(rune);
      int? nb = int.tryParse(char);
      if(nb != null) {
        total += nb;
      }
    });

    print(encoded);

    List<int> rawIdNewVals = encoded.runes.toList();

    // decrease every 4 values from encodedRaw by the sum in desc order
    for(int i = 0; i < encoded.runes.length; i+=4) {
      int rune = encoded.runes.elementAt(i);
      String char = new String.fromCharCode(rune);
      int pos = alphabets.indexOf(char);
      int gap = alphabets.length - pos;
      int loweredPos = gap - total;
      if(loweredPos < 0) {
        loweredPos = loweredPos.abs();
      } else {
        loweredPos = alphabets.length - loweredPos;
      }
      String elevatedChar = alphabets[loweredPos];
      rawIdNewVals[i] = elevatedChar.codeUnitAt(0);
    }

    String encodedRawId = "";

    for (var element in rawIdNewVals) {
      encodedRawId += new String.fromCharCode(element);
    }

    String elevated = stringToBase64.decode(encodedRawId.toString());
    num raw = num.parse(elevated) / 4;

    return raw.toStringAsFixed(0);
  }

}