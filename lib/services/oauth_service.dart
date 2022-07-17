import 'dart:ffi';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<Map?> fbLogin() async {
    Map<String, dynamic> userData;
    final result = await FacebookAuth.i.login(
        permissions: ["public_profile", "email"]
    );

    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      userData = await FacebookAuth.i.getUserData(
        fields: "email,name",
      );
      userData["token"] = accessToken.token;
      userData["exp"] = accessToken.expires;
      userData["isExpired"] = accessToken.isExpired;
      userData["applicationId"] = accessToken.applicationId;

      return userData;
    } else {
      print(result.status);
      print(result.message);
    }
    return null;
}

void fbLogout() async {
  await FacebookAuth.i.logOut();
}

Future<AccessToken?> checkLoggedIn() async {
  final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
// or FacebookAuth.i.accessToken
  if (accessToken != null) {
    // user is logged
    return accessToken;
  }
  return null;
}