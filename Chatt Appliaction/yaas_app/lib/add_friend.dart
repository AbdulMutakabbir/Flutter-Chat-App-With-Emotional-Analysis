import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget{

  final contactList;
  final userId;
  final username;

  AddFriend({this.contactList, this.userId, this.username});

  @override
  State<StatefulWidget> createState() => AddFriendState();

}

class AddFriendState extends State<AddFriend>{

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
        ),
      body: Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('userData')
                .orderBy('username')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return ListView.builder(
                    itemCount: 0,
                    itemBuilder: (context, index) {
                      return Center(child: Text("Please wait while we add users",style: TextStyle(fontSize: 23),));
                    });
              } else {
                print("users itemcount :${snapshot.data.documents.length}");
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot usersList = snapshot.data.documents[index];
                    return UsersListWidget(myName: widget.username,myId: widget.userId,userName: usersList['username'],userId: usersList['user_id'],isNull: (widget.contactList.contains(usersList['user_id'])) ? true : false );
                  },
                );
              }
            }),
      ));
  }


}

class UsersListWidget extends StatefulWidget{

  final userName;
  final userId;
  final myId;
  final myName;
  bool isNull;

  UsersListWidget({this.userName, this.isNull, this.userId, this.myId, this.myName});

  @override
  State<StatefulWidget> createState() => UsersListWidgetState();
}

class UsersListWidgetState extends State<UsersListWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: widget.isNull ? null :()async{
          setState(() {
            widget.isNull = true;
          });
          DocumentReference docId = await Firestore.instance.collection("chats").add({
            "contact1": widget.userId,
            "contact2": widget.myId
          });
          print("document id (chatId):"+docId.documentID);
          await Firestore.instance.collection("userData").document(widget.myId).collection("friends").document(widget.userId).setData({
            "chat_id": docId.documentID,
            "name": widget.userName,
            "user_id": widget.userId
          });
          await Firestore.instance.collection("userData").document(widget.userId).collection("friends").document(widget.myId).setData({
            "chat_id": docId.documentID,
            "name": widget.myName,
            "user_id": widget.myId
          });
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(top:8.0,bottom:8.0,left:16),
            child: Text(
              widget.userName,
              style: TextStyle(
                fontSize: 32,
                color: widget.isNull ? Colors.grey : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}