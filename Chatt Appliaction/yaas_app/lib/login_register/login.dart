import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yaas_app/auth.dart';
import 'package:yaas_app/login_register/login_email.dart';
import 'package:yaas_app/login_register/login_phone.dart';

import './Mesanger.dart';

class Login extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignIn;

  Login({this.auth, this.onSignIn});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height-84,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
//                LoginBtns(
//                  name:'Facebook',
//                  icon: FontAwesomeIcons.facebookF,
//                  color: Color.fromRGBO(59, 89, 152, 1),
//                ),
//                GestureDetector(
//                  onTap: (){},
//                  child: LoginBtns(
//                    name:'Google',
//                    icon: FontAwesomeIcons.google,
//                    color: Color.fromRGBO(231, 71, 51, 1),
//                  ),
//                ),
//                LoginBtns(
//                  name:'Twitter',
//                  icon: FontAwesomeIcons.twitter,
//                  color: Color.fromRGBO(89, 187, 216, 1),
//                ),
//                LoginBtns(
//                  name:'Yahoo',
//                  icon: FontAwesomeIcons.yahoo,
//                  color: Color.fromRGBO(114, 14, 158, 1),
//                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhoneLogin(onSignedIn: widget.onSignIn)));
                  },
                  child: LoginBtns(
                    name:'Phone',
                    icon: FontAwesomeIcons.phoneAlt,
                    color: Color.fromRGBO(169, 169, 169, 1),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailLogin(auth: widget.auth,onSignedIn: widget.onSignIn,)));
                  },
                  child: LoginBtns(
                    name:'Email',
                    icon: FontAwesomeIcons.solidEnvelope,
                    color: Color.fromRGBO(169, 169, 169, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class LoginBtns extends StatelessWidget
{
  final Color color;
  final String name;
  final IconData icon;
  LoginBtns({this.name,this.icon,this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:42,
      margin: EdgeInsets.only(bottom: 16,left: 24,right: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left:16),
            ),
            Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
            Padding(
              padding: EdgeInsets.only(left:16),
            ),
            Text("Continue with ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                )
            ),
            Text(name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                )
            ),
          ],
        ),
      ),
    );
  }

}
/*

*/