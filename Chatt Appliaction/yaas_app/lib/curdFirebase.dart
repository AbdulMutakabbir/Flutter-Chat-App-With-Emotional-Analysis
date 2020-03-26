

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CURD{
  Future<int> getEmotionCount(String userID);
}

class FirebaseCURD implements CURD{
  
  @override
  Future<int> getEmotionCount(userID) async{
    DocumentSnapshot emotionDocument = await Firestore.instance.collection("emotions").document(userID).get();
    return emotionDocument["emotion_count"];
  }

}