import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../cryptoUtils.dart';
import '../models/User.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'oauth_service.dart';

Future<String> loadAsset() async {
return await rootBundle.loadString('assets/config.json');
}

Future<List<User>> getUsers() async {
  var value = await loadAsset();
  CryptoUtils cryptoUtils = CryptoUtils();

  var config = jsonDecode(value);
  var client = http.Client();

  String apiUrl = '${config['protocol']}://${config['host']}:${config['port']}/${config['endpoint']}';
  AccessToken? accessToken = await checkLoggedIn();

  if(accessToken == null) {
    // throw error USER NOT LOGGED IN
    throw 'USER NOT LOGGED IN';
  }

  String encoded = await cryptoUtils.encode(accessToken.applicationId);

/*
  var response = await client.get(Uri.parse(apiUrl + '/users/'),
      headers: {
        HttpHeaders.authorizationHeader: encoded
      });
  print("rrrrrr" + response.body + "\n" + response.statusCode.toString() + "\n" + response.headers.toString());
  */
  var faked = [User(1, "yoyo", "bill")];
  return faked;
}
