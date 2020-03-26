import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:date_format/date_format.dart';

class Messanger extends StatefulWidget {
//  final BaseAuth auth;
//  final VoidCallback onSignOut;
//  Messanger({this.auth,this.onSignOut});
//  void _signOut() async{
//    try{
//      await auth.signOut();
//      onSignOut();
//    }catch(e){
//      print(e);
//    }
//  }

  final String userId;
  final String username;
  final String fId;
  final String fUsername;
  final String chatId;

  String a;

  Messanger(
      {this.userId, this.fId, this.chatId, this.username, this.fUsername});

  @override
  State<Messanger> createState() => MessangerState();
}

class MessangerState extends State<Messanger> {
  TextEditingController msgControler = new TextEditingController();

  void addEmotionData(Map emotion) async{

    if(emotion['sadness'] >= 0.4 || emotion['joy'] <= 0.4 || emotion['anger'] >= 0.5 || emotion['confident'] <= 0.4 ){
      await Firestore.instance.collection("emotions")
          .document(widget.userId)
          .collection("emotionData")
          .add({
        "joy":emotion["joy"],
        "sadness":emotion["sadness"],
        "anger":emotion["anger"],
        "confident":emotion["confident"],
        "time": Timestamp.now()//Timestamp.fromDate(DateTime.parse("2020-03-01 20:18:04Z"))
          });

      DocumentSnapshot data= await Firestore.instance.collection('emotions').document(widget.userId).get();
      int newCount = data['emotion_count'] + 1;
      await Firestore.instance.collection("emotions").document(widget.userId).updateData({"emotion_count" : newCount});

      print('emotion_count: ${newCount}');
    }
  }

  void normalizeEmotionScore(String jsonResponse){
    Map emotions = {"joy":0.0,"sadness":0.0,"anger":0.0,"confident":0.0};
    Map jsonMap = jsonDecode(jsonResponse);
    if(jsonMap['document_tone']['tones'].length != 0)
    {
      for(var i in jsonMap['document_tone']['tones'] ){
        switch(i['tone_id']){
          case 'anger':
            emotions['anger'] += i['score'];
            break;
          case 'joy':
            emotions['joy'] += i['score'];
            break;
          case 'sadness':
            emotions['sadness'] += i['score'];
            break;
          case 'confident':
            emotions['confident'] += i['score'];
            break;
        }
      }
      var sentence_counter = 1;

      var sentence_tones = jsonMap['sentences_tone'];
      if(sentence_tones != null)
      {
        assert (sentence_tones is List);

        for( var i in sentence_tones){
          sentence_counter += 1;
          for(var j in i['tones']){
            switch(j['tone_id']){
              case 'anger':
                emotions['anger'] += j['score'];
                break;
              case 'joy':
                emotions['joy'] += j['score'];
                break;
              case 'sadness':
                emotions['sadness'] += j['score'];
                break;
              case 'confident':
                emotions['confident'] += j['score'];
                break;
            }
          }
        }
      }
      emotions['joy'] /= sentence_counter;
      emotions['sadness'] /= sentence_counter;
      emotions['anger'] /= sentence_counter;
      emotions['confident'] /= sentence_counter;
      print('$emotions');

      addEmotionData(emotions);
    }

  }

  void addMsg(String msg) async {
    await Firestore.instance.collection('chats')
        .document(widget.chatId)
        .collection("messages")
        .add({
      "message": msg,
      "reciver_id": widget.fId,
      "reciver_name": widget.fUsername,
      "sender_name": widget.username,
      "sender_id": widget.userId,
      "time": Timestamp.now()
    });
  }

  void delMsg(DocumentSnapshot doc) async {
    await Firestore.instance
        .collection('messages')
        .document(doc.documentID)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(115, 40, 182, 1),
        title: Text(widget.fUsername,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(220, 215, 220, 1),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('chats')
                  .document(widget.chatId)
                  .collection("messages")
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  const Text('No Messages Available');
                else {
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot myMsg = snapshot.data.documents[index];
                      var isMe = (myMsg['sender_id'] == widget.userId);
                      final msgCrossAxiesAlignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                      final msgBackgroundColor = !isMe ? [Color.fromRGBO(115, 40, 182, 1), Color.fromRGBO(215, 140, 250, 1)] : [Colors.deepPurple, Color.fromRGBO(115, 40, 182, 1)];
                      final msgBorderRadius = isMe
                          ? BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(2), bottomLeft: Radius.circular(15),bottomRight: Radius.circular(20))
                          : BorderRadius.only(topLeft: Radius.circular(2),topRight: Radius.circular(25), bottomLeft: Radius.circular(20),bottomRight: Radius.circular(15));
                      final msgMargin = isMe ? EdgeInsets.only(bottom:8,right:8,left:25) : EdgeInsets.only(bottom:8,left:8,right:25);
                      final msgPadding = isMe ? EdgeInsets.only(left:8.0,bottom:10.0) : EdgeInsets.only(bottom:10.0,right: 8.0);

                      var msgTime = DateTime.fromMillisecondsSinceEpoch(1000*int.parse(myMsg['time'].toString().replaceAll('Timestamp(seconds=', "").substring(0,10)));
                      final displayTime = (msgTime.isAfter(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day))) ? formatDate(msgTime, [HH,":",nn]): formatDate(msgTime, [dd,"-",mm,"-","yyyy"]);

                      return Column(
                        crossAxisAlignment: msgCrossAxiesAlignment,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              margin: msgMargin,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: [0.0, 1.0],
                                    colors: msgBackgroundColor,
                                  ),
                                  borderRadius: msgBorderRadius,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: msgPadding,
                                    child: Text('${myMsg['message']}', style: TextStyle(color: Colors.white),),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: isMe ? 3 : null,
                                    left: isMe ? null: 3,
                                    child: Text('$displayTime',style:  TextStyle(color: Colors.white60,fontSize: 10),),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return ListView();
              },
            ),
          ),
          Container(
            height: 75,
            color: Color.fromRGBO(115, 40, 182, 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 54,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: msgControler,
                      decoration: InputDecoration(
                        hasFloatingPlaceholder: false,
                        labelText: 'Meassage',
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(225, 80, 232, 1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.white,
                  onPressed: () {
                    if (msgControler.text.isNotEmpty && msgControler.text.trim() != ""){
                      String msg = msgControler.text.trim();
                      addMsg(msg);
                      if(msg.split(" ").length >= 3){
                        postToneAnalyzer(msg);
                      }
                    }
                    setState(() {
                      msgControler.clear();
                    });
//                  var random = Random();
//                    Map emotions = {"joy": random.nextDouble(),"sadness":random.nextDouble(),"anger":random.nextDouble(),"confident":random.nextDouble()};
//                    addEmotionData(emotions);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void postToneAnalyzer(String msg) async {
    print("Tone Analyzer called");
    var url = "https://api.eu-gb.tone-analyzer.watson.cloud.ibm.com/instances/ca30ebb7-22ab-4650-ac83-060cd62e1891/v3/tone?version=2017-09-21";
    var body = json.encode({ "text": msg});
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Basic YXBpa2V5OlA0UjNNTHBEXzNyMjBBSTZwbGhTUHd3MXpTZXltb0lwa281ZzJGZy1XWHd6',
    };

    var response = await http.post(
        url,
        headers: headers,
        body: body
    );
    print("${response.body}");
    normalizeEmotionScore(response.body);
  }
}


//var jsonResponse = '{"document_tone": {"tones": [{"score": 0.547339, "tone_id": "joy", "tone_name": "Joy"}, {"score": 0.55795, "tone_id": "tentative", "tone_name": "Tentative"}]}, "sentences_tone": [{"sentence_id": 0, "text": "this can be a joyful day but the bad army has destroyed the crops.", "tones": [ {"score": 0.587629, "tone_id": "sadness", "tone_name": "Sadness"},{"score": 0.587629, "tone_id": "sadness", "tone_name": "Sadness"},{"score": 0.587629, "tone_id": "sadness", "tone_name": "Sadness"}]}, {"sentence_id": 1, "text": "times are bad but we must proceed with caution and not worry about the good times and the happy days that have gone by during this time to make us happy.", "tones": [{"score": 0.81751, "tone_id": "joy", "tone_name": "Joy"}]}, {"sentence_id": 2, "text": "we are a bunch of happy joyfull good loving emotional fools that may get angry.", "tones": [{"score": 0.600471, "tone_id": "anger", "tone_name": "Anger"}, {"score": 0.647986, "tone_id": "tentative", "tone_name": "Tentative"}]}]}';

