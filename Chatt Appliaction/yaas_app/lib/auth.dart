import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yaas_app/userData.dart';

abstract class BaseAuth{
  Future<String> signinWithEmailAndPassword(String email,String password);
  Future<String> createWithEmailAndPassword(String email,String password, String username, String number);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signinWithEmailAndPassword(String email,String password) async{
      try{
        FirebaseUser user  = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

        UserData.userId = user.uid;

        print(user.uid);

        DocumentSnapshot userdata = await Firestore.instance.collection("userData").document(UserData.userId).get();
        UserData.userName = userdata['username'];

        print("username: ${UserData.userName}");
        return user.uid;
      }catch(e){
        String returnStr;
        if(Platform.isAndroid){
          switch(e.message){
            case 'There is no user record corresponding to this identifier. The user may have been deleted.':
              returnStr = "no_usr";
              break;
            case 'The password is invalid or the user does not have a password.':
              returnStr = "no_pas";
              break;
            case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
              returnStr = "no_net";
              break;
            default:
              print(e.message);
          }
        }else if(Platform.isIOS){
          switch(e.message){
            case 'Error 17011':
              returnStr = "no_usr";
              break;
            case 'Error 17009':
              returnStr = "no_pas";
              break;
            case 'Error 17020':
              returnStr = "no_net";
              break;
          }
        }
        return returnStr;
      }


  }

  @override
  Future<String> createWithEmailAndPassword(String email, String password,String username, String number) async{
    FirebaseUser user;
    try {
      user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("user: ${user.uid}");
    }catch(e){
      print("createEmail error ${e.message}");
      switch(e.message){
        case "The email address is already in use by another account.":
          return "usr_ex";
      }
    }

    await Firestore.instance.collection("userData").document(user.uid).setData({
      "dp": "",
      "mobile": number,
      "user_id": user.uid,
      "username": username
    });

    await Firestore.instance.collection("emotions").document(user.uid).setData({
      "username": username,
      "user_id": user.uid,
      "emotion_count": 0,
      "test_taken": 0
    });

    UserData.userId = user.uid;
    UserData.userName = username;

    return user.uid;
  }

  @override
  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user != null)
    {
      UserData.userId = user.uid;

      if(UserData.userId != null) {
        DocumentSnapshot userdata = await Firestore.instance.collection("userData").document(UserData.userId).get();
        UserData.userName = userdata['username'];
      }else {
        UserData.userName = null;
      }

      return user.uid;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    UserData.userName = null;
    UserData.userId = null;
    String user = await currentUser();
    print("signing out user: "+user);
    return _firebaseAuth.signOut();
  }


}