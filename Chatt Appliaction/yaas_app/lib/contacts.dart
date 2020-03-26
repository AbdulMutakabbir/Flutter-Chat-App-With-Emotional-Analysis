import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yaas_app/add_friend.dart';
import 'package:yaas_app/login_register/Mesanger.dart';
import 'package:yaas_app/curdFirebase.dart';

import 'package:yaas_app/PHQ9.dart';

enum TestState {
  doTest,
  doNotTest
}

class Contacts extends StatefulWidget {
  final String userId;
  final String userName;
  final VoidCallback onSignOut;

  Contacts({this.userId, this.userName, this.onSignOut});

  @override
  State<StatefulWidget> createState() => ContactsSate();
}

class ContactsSate extends State<Contacts> {

  TestState _testState = TestState.doNotTest;
  var contactList = new List();
  
  final CURD _curd= new FirebaseCURD();

  void _setDoNotTest(){
    setState(() {
      _testState = TestState.doNotTest;
    });
  }

  @override
  void initState() {

    _testState = TestState.doNotTest;

    WidgetsBinding.instance.addPostFrameCallback((_){
      _curd.getEmotionCount(widget.userId).then((int emotionCount){
        if(emotionCount >= 5){
          setState(() {
            _testState = TestState.doTest;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("contacts");
    return (_testState == TestState.doTest) ? PHQ9Test(userId:widget.userId,doneTest: _setDoNotTest) : Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(115, 40, 182, 1),
          title: Text(
            'YAAS App',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () async{
                await widget.onSignOut();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(115, 40, 182, 1),
          child: Center(child: Icon(Icons.person_add,)),
          onPressed: (){
            print(contactList.toString());
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddFriend(contactList: contactList,userId: widget.userId,username: widget.userName,)));
          },
        ),
        backgroundColor: Color.fromRGBO(220, 215, 220, 1),
        body: Container(
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('userData')
                  .document(widget.userId)
                  .collection('friends')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ListView.builder(
                      itemCount: 0,
                      itemBuilder: (context, index) {
                        return Center(child: Text("Please wait while loading",style: TextStyle(fontSize: 23),));
                      });
                } else {
                  if(!contactList.contains(widget.userId)){
                    contactList.add(widget.userId);
                    }
                  print("contacts count :${snapshot.data.documents.length}");
                  if(snapshot.data.documents.length == 0){
                    return Center(child: Text("Find Some Friends",style: TextStyle(fontSize: 23),));
                  }
                  else {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot myContact = snapshot.data
                            .documents[index];
                        if (!contactList.contains(myContact['user_id'])) {
                          contactList.add(myContact['user_id']);
                        }
                        return ContactListWidget(
                            myContact['name'], myContact['user_id'],
                            myContact['chat_id']);
                      },
                    );
                  }
                }
              }),
        ));
  }

  Widget ContactListWidget(String fUsername,String fId,String chatId) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  Messanger(username: widget.userName,userId: widget.userId, fId: fId,fUsername: fUsername,chatId: chatId)));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(top:8.0,bottom:8.0,left:16),
            child: Text(
              fUsername,
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }
}
