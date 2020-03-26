import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';
import 'package:yaas_dashboard/analytics.dart';
import 'package:yaas_dashboard/general/appBar.dart';

class Patients extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    print("patients");
    return Scaffold(
      appBar: AppBarWithAction([PHQ9Info()]),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("emotions")
              .orderBy("test_taken",descending: true)
              .snapshots(),
          builder: (context, snapshot){
            if (!snapshot.hasData) {
              return ListView.builder(
                  itemCount: 0,
                  itemBuilder: (context, index) {
                    return Center(child: Text("Please wait while loading",style: TextStyle(fontSize: 23),));
                  });
            }else{
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot myPatient = snapshot.data.documents[index];
                    int emotionCount = myPatient['emotion_count'];
                    int testTaken = myPatient['test_taken'];
                    return GestureDetector(
                      onTap: (){
                        print("userid: ${myPatient['user_id']}");
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Analytics(UserId: myPatient["user_id"])));
                      },
                      child: Card(
                        elevation: 3,
                        color: (emotionCount <= 5 && testTaken == 0) ? AppColors["Grey"] : (testTaken <= 5) ? AppColors["BlueGrey"] : (testTaken <= 9) ? AppColors["Green"] : (testTaken <= 14) ? AppColors["Yellow"] :(testTaken <= 19) ? AppColors["Orange"] : AppColors["Red"],
                        child: Padding(
                          padding: const EdgeInsets.only(left:18.0,top:8,bottom: 8,right: 8),
                          child: Text(
                            myPatient['username'],
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: AppColors["White"]
                            )
                          ),
                        ),
                      ),
                    );
                  }
              );
            }
          },
        )
      ),
    );
  }
  
}