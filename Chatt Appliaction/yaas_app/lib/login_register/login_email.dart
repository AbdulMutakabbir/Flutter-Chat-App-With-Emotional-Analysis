import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaas_app/auth.dart';
import 'package:yaas_app/auth.dart';

enum FormType { login, register }

class EmailLogin extends StatefulWidget {
  final VoidCallback onSignedIn;
  final BaseAuth auth;

  EmailLogin({this.auth, this.onSignedIn});

  @override
  State<StatefulWidget> createState() => EmailLoginState(auth: auth);
}

class EmailLoginState extends State<EmailLogin> {
  final BaseAuth auth;
  final emailPasswordLoginFormKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;

  String _password;
  String _email;
  String _username;
  String _contact;

  bool isLoginButtonEnabled = true;

  String errorMessage = "";

  EmailLoginState({this.auth});

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Form(
              key: emailPasswordLoginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                      Center(
                        child: Text(
                          _formType == FormType.login ? "SignIn" : "Register",
                          style: TextStyle(
                              fontSize: 64,
                              color: Color.fromRGBO(115, 40, 182, 1)),
                        ),
                      )
                    ] +
                    (_formType == FormType.register
                        ? RegisterExtraField()
                        : []) +
                    EmailPasswordFields() +
                    EmailPasswordButtons(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> EmailPasswordFields() {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty
              ? 'Email can not be empty'
              : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)
                  ? null
                  : 'Invalid email',
          onSaved: (value) => _email = value.trim(),
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          validator: (value) => value.isEmpty
              ? 'Password can not be empty'
              : (value.length < 8)
                  ? 'Password Should be atleast 8 characters'
                  : null,
          onSaved: (value) => _password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
      ),
      Center(
          child: Text(
        "$errorMessage",
        style: TextStyle(color: Colors.red),
      ))
    ];
  }

  List<Widget> RegisterExtraField() {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          validator: _formType == FormType.login
              ? null
              : (value) => value.isEmpty
                  ? 'Username cannot be empty'
                  : (value.length > 20)
                      ? 'Username Should be lessthan 20 characters'
                      : null,
          onSaved: (value) => _username = value.trim(),
          decoration: InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          keyboardType: TextInputType.number,
          validator: _formType == FormType.login
              ? null
              : (value) => value.isEmpty
                  ? 'Contact Number can not be empty.'
                  : value.length != 10
                      ? 'Invalid length'
                      : !RegExp(r'(^[0-9]{10}$)').hasMatch(value)
                          ? "Invalid Number"
                          : null,
          onSaved: (value) => _contact = "+91" + value.trim(),
          decoration: InputDecoration(
            labelText: 'Contact Number',
            prefixText: "+91",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
      ),
    ];
  }

  List<Widget> EmailPasswordButtons() {
    return [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Color.fromRGBO(115, 40, 182, 1),
          ),
          child: FlatButton(
            child: Text(
              (_formType == FormType.login) ? "login" : "Register",
              style: TextStyle(color: Colors.white, fontSize: 23),
            ),
            onPressed: !isLoginButtonEnabled
                ? null
                : () {
                    setState(() {
                      print("login button disabled");
                      isLoginButtonEnabled = false;
                    });
                    submitForm(context);
                  },
          ),
        ),
      ),
      FlatButton(
        child: Text(
          (_formType == FormType.login)
              ? "Not a member? Register."
              : "Already a member? SignIn",
        ),
        onPressed: () {
          setState(() {
            emailPasswordLoginFormKey.currentState.reset();
            errorMessage = "";
            switchFormType();
          });
        },
      )
    ];
  }

  bool validateForm() {
    final form = emailPasswordLoginFormKey.currentState;
    form.save();

    if (form.validate()) {
      print("form valid $_email $_password");
      return true;
    } else {
      print("form invalid $_email}");
      return false;
    }
  }

  Future<Widget> submitForm(BuildContext context) async {
    if (validateForm()) {
      try {
        String userId;
        if (_formType == FormType.login) {
          userId =
              await widget.auth.signinWithEmailAndPassword(_email, _password);
          print("SignIn  -->  user id: $userId");
          switch (userId) {
            case "no_usr":
              setState(() {
                errorMessage = "No such email exists.";
              });
              break;
            case "no_net":
              setState(() {
                errorMessage = "Network issue please. Try again.";
              });
              break;
            case "no_pas":
              setState(() {
                errorMessage = "Invalid password";
              });
              break;
            default:
              if (userId != null) {
                widget.onSignedIn();
              }
          }
        } else {
          userId = await widget.auth.createWithEmailAndPassword(
              _email, _password, _username, _contact);
          print("register  --> User id: $userId");
          switch (userId) {
            case "usr_ex":
              setState(() {
                errorMessage = "Email already exist";
              });
              break;
            default:
              if (userId != null) {
                widget.onSignedIn();
                setState(() {
                  errorMessage = "";
                });
              } else {
                setState(() {
                  errorMessage = "Error in Registering. Please try again";
                });
              }
          }
          print("signedin $userId");
        }
      } catch (e) {
        print("error: $e");
      }
    }
    setState(() {
      print("login button enabled");
      isLoginButtonEnabled = true;
    });
  }

  void switchFormType() {
    (_formType == FormType.login)
        ? _formType = FormType.register
        : _formType = FormType.login;
  }
}
