import 'package:flutter/material.dart';
import 'package:yaas_app/auth.dart';

import './login.dart';


class MainLogReg extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  MainLogReg({this.auth, this.onSignedIn});

  @override
  State<MainLogReg> createState() => MainLogRegState();
}

class MainLogRegState extends State<MainLogReg>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(115, 40, 182, 1),
        title: Text('YAAS App',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Login(auth: widget.auth,onSignIn: widget.onSignedIn),
        ),
      ),
    );
  }

}