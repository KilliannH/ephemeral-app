import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../constants.dart';
import '../services/oauth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Map? _userData;

  void _doLogin() async {
    final userData = await fbLogin();

      setState(() {
        _userData = userData;
        print(_userData.toString());
      });
  }

  void _doLogout() async {
    // todo check the return of this
    fbLogout();
    setState(() {
      _userData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.FacebookNew,
              onPressed: () {
                _doLogin();
              },
            ),
          ElevatedButton(
            style: raisedButtonStyle,
            onPressed: () {
              _doLogout();
              },
            child: Text('Logout'),
          )
          ],
        ),
      ),
    );
  }
}
