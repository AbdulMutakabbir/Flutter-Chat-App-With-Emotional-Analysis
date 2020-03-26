import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaas_app/ProgressIndecator.dart';
import 'package:yaas_app/auth.dart';
import 'package:yaas_app/contacts.dart';
import 'package:yaas_app/login_register/Mesanger.dart';
import 'package:yaas_app/login_register/login_email.dart';
import 'package:yaas_app/login_register/main.dart';
import 'package:yaas_app/userData.dart';

enum AuthStatus{
  signedIn,
  notSignedIn
}

enum CheckState{
  inProgress,
  isDone
}

class RootPage extends StatefulWidget{
  final BaseAuth auth;

  RootPage({this.auth});

  @override
  State<StatefulWidget> createState() => RootPageState();

}

class RootPageState extends State<RootPage>{
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  CheckState _checkState = CheckState.inProgress;

  @override
  Widget build(BuildContext context) {
    print("root");
    return (_checkState == CheckState.inProgress) ? ProgressIndecator() : (_authStatus == AuthStatus.notSignedIn) ? MainLogReg(auth: widget.auth,onSignedIn: _signedIn,) : Contacts(userId: UserData.userId, userName: UserData.userName,onSignOut: _signOut,);
  }

  @override
  void initState() {
    super.initState();

    _checkState = CheckState.inProgress;
    widget.auth.currentUser().then((userId){
      setState((){
         if(userId == null)
           _authStatus = AuthStatus.notSignedIn;
         else
           _authStatus = AuthStatus.signedIn;
         _checkState = CheckState.isDone;
      });
    });
  }

  void _signedIn() {
    setState(() {
      Navigator.of(context).pop();
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signOut() async{
    await widget.auth.signOut();
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }
}