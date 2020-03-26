import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yaas_app/login_register/Mesanger.dart';

class PhoneLogin extends StatefulWidget {

  final VoidCallback onSignedIn;

  PhoneLogin({this.onSignedIn});

  @override
  State<StatefulWidget> createState() => PhoneLoginState();
}

class PhoneLoginState extends State<PhoneLogin> {
  final _otpController = TextEditingController();
  final phoneLoginFormKey = new GlobalKey<FormState>();

  String _phoneNo;


  Future<bool> phoneLogin(String phoneNO,BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phoneNO,
        timeout: Duration(seconds: 60),
        verificationCompleted: (FirebaseUser user) async {
          Navigator.of(context).pop();
          if (user != null) {
            print("verificationCompleted: $user");
          } else {
            print("verificationCompletion Error");
          }
          Navigator.of(context).pop();
        },
        verificationFailed: (AuthException e) {
          Navigator.of(context).pop();
          print("verificationFailed  ${e.message} ");
        },
    codeSent: (String verificationId, [int forceResendToken]) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Enter OTP"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _otpController,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("confirm"),
                    textColor: Colors.white,
                    color: Color.fromRGBO(115, 40, 182, 1),
                    onPressed: () async {
                      final code = _otpController.text.trim();
                      AuthCredential credential =
                          PhoneAuthProvider.getCredential(
                              verificationId: verificationId, smsCode: code);

                      FirebaseUser user = await _auth.signInWithCredential(credential);

                      if (user != null) {
                        widget.onSignedIn();
                        print("user id: ${user.uid}");
                      } else {
                        print("user error");
                      }
                    },
                  )
                ],
              );
            },
            barrierDismissible: false,
          );
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(115, 40, 182, 1),
        title: Text(
          'YAAS App',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Phone SignIn",
                    style: TextStyle(fontSize: 32, color: Color.fromRGBO(115, 40, 182, 1)),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 32.0, right: 32.0),
                child: Form(
                  key: phoneLoginFormKey,
                  child: TextFormField(
                    validator: (value) => value.length != 10 ? "Invalid phone number." : null,
                    onSaved: (value) => _phoneNo = "+91"+value,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      prefix: Text("+91 "),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color.fromRGBO(115, 40, 182, 1),
                  ),
                  child: FlatButton(
                    child: Text(
                      "SignIn",
                      style: TextStyle(color: Colors.white,fontSize: 23),
                    ),
                    onPressed: (){
                      submitForm();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isValid() {
    final form = phoneLoginFormKey.currentState;
    form.save();
    if(form.validate()){
      print("valid phone no:  $_phoneNo");
      return true;
    }else{
      print("invalid phone number:  $_phoneNo");
      return false;
    }
  }

  void submitForm() {
    if(isValid()){
      phoneLogin(_phoneNo, context);
    }
  }
}
