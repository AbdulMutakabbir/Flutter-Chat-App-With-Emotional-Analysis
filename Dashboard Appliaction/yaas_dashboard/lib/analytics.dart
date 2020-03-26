import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';
import 'package:yaas_dashboard/emotions/allChartsUI.dart';
import 'package:yaas_dashboard/emotions/emotionStorage.dart';
import 'package:yaas_dashboard/emotions/emotionsGenericDateStorage.dart';
import 'package:yaas_dashboard/emotions/emotionsGenericStorage.dart';
import 'package:yaas_dashboard/general/appBar.dart';

class Analytics extends StatefulWidget {
  final String UserId;

  Analytics({this.UserId});

  @override
  State<StatefulWidget> createState() => AnalyticsState();
}

class AnalyticsState extends State<Analytics> {

  int quertLimit = 30;

  List<EmotionLineDataSeries> joyDataList;
  List<EmotionLineDataSeries> sadnessDataList;
  List<EmotionLineDataSeries> angerDataList;

  List<EmotionBarDataSeries> joyDateList;
  List<EmotionBarDataSeries> angerDateList;
  List<EmotionBarDataSeries> sadnessDateList;

  List<EmotionSeries> emotionSeriesList;

  Map<DateTime, double> mapJoy;
  Map<DateTime, double> mapAnger;
  Map<DateTime, double> mapSadness;

  double joyValue;
  double angerValue;
  double sadnessValue;

  @override
  void initState() {
    joyDataList = List();
    sadnessDataList = List();
    angerDataList = List();

    joyDateList = List();
    angerDateList = List();
    sadnessDateList = List();

    emotionSeriesList = List();

    mapJoy = Map();
    mapAnger = Map();
    mapSadness = Map();

    joyValue = 0.0;
    angerValue = 0.0;
    sadnessValue = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppBar(),
        backgroundColor: Colors.white,
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _streamEmotions(context),
        )));
  }


  Widget _streamEmotions(context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("emotions")
          .document(widget.UserId)
          .collection("emotionData")
          .limit(quertLimit)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print("no data available for charts");
          return Text("No Data Available");
        }
        else {
          List<DocumentSnapshot> myData = snapshot.data.documents;

          int i;
          for (i = 0; i < myData.length; i++) {

            var msgTime = DateTime.fromMillisecondsSinceEpoch(1000 *
                int.parse(myData[i]["time"]
                    .toString()
                    .replaceAll('Timestamp(seconds=', "")
                    .substring(0, 10)));

            if (mapJoy[msgTime] != null) {
              mapJoy[msgTime] += myData[i]["joy"];
              mapAnger[msgTime] += myData[i]["anger"];
              mapSadness[msgTime] += myData[i]["sadness"];
            } else {
              mapJoy.addAll({msgTime: myData[i]["joy"]});
              mapAnger.addAll({msgTime: myData[i]["anger"]});
              mapSadness.addAll({msgTime: myData[i]["sadness"]});
            }

            joyDataList.add(EmotionLineDataSeries(
                value: myData[i]["joy"] * 100, counter: i));
            joyValue += myData[i]["joy"] * 100;
            angerDataList.add(EmotionLineDataSeries(
                value: myData[i]["anger"] * 100, counter: i));
            angerValue += myData[i]["anger"] * 100;
            sadnessDataList.add(EmotionLineDataSeries(
                value: myData[i]["sadness"] * 100, counter: i));
            sadnessValue += myData[i]["sadness"] * 100;
          }

          mapJoy.forEach((key, value) {
            joyDateList
                .add(EmotionBarDataSeries(value: value * 100, date: key));
          });

          mapAnger.forEach((key, value) {
            angerDateList
                .add(EmotionBarDataSeries(value: value * 100, date: key));
          });

          mapSadness.forEach((key, value) {
            sadnessDateList
                .add(EmotionBarDataSeries(value: value * 100, date: key));
          });

          joyValue /= i;
          angerValue /= i;
          sadnessValue /= i;

          if (joyValue == 0.0) {
            joyValue = 3;
          }
          if (angerValue == 0.0) {
            angerValue = 3;
          }
          if (sadnessValue == 0.0) {
            sadnessValue = 3;
          }

          emotionSeriesList.add(EmotionSeries(
              emotion: "Joy",
              value: joyValue,
              color: charts.ColorUtil.fromDartColor(
                  AppColors["AmberChartColor"])));
          emotionSeriesList.add(EmotionSeries(
              emotion: "Anger",
              value: angerValue,
              color:
                  charts.ColorUtil.fromDartColor(AppColors["RedChartColor"])));
          emotionSeriesList.add(EmotionSeries(
              emotion: "Sadness",
              value: sadnessValue,
              color:
                  charts.ColorUtil.fromDartColor(AppColors["BlueChartColor"])));
        }

        return AllChartsUI(joyDataList: joyDataList, angerDataList: angerDataList, sadnessDataList: sadnessDataList, joyDateList: joyDateList, angerDateList: angerDateList, sadnessDateList: sadnessDateList, emotionSeriesList: emotionSeriesList);
      },
    );
  }
}
