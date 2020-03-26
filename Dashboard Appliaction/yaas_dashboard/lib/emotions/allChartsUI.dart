import 'package:flutter/material.dart';
import 'package:yaas_dashboard/emotions/emotionsGenericDateStorage.dart';
import 'package:yaas_dashboard/emotions/emotionsGenericStorage.dart';
import 'package:yaas_dashboard/emotions/joyBarChart.dart';
import 'package:yaas_dashboard/emotions/joyLineChart.dart';
import 'package:yaas_dashboard/emotions/sadnessBarChart.dart';
import 'package:yaas_dashboard/emotions/sadnessLineChart.dart';
import 'package:yaas_dashboard/emotions/angerBarChart.dart';
import 'package:yaas_dashboard/emotions/angerLineChart.dart';
import 'package:yaas_dashboard/emotions/emotionStorage.dart';


class AllChartsUI extends StatelessWidget{

  final List<EmotionLineDataSeries> joyDataList;
  final List<EmotionLineDataSeries> angerDataList;
  final List<EmotionLineDataSeries> sadnessDataList;

  final List<EmotionBarDataSeries> joyDateList;
  final List<EmotionBarDataSeries> angerDateList;
  final List<EmotionBarDataSeries> sadnessDateList;

  final List<EmotionSeries> emotionSeriesList;

  const AllChartsUI({@required this.joyDataList,@required this.angerDataList,@required this.sadnessDataList,@required this.joyDateList,@required this.angerDateList,@required this.sadnessDateList,@required this.emotionSeriesList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EmotionChart(pointData: emotionSeriesList),
            )),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              ChartColumn(context, JoyBarChart(pointData: joyDateList,), JoyLineChart(pointData: joyDataList,)),
              ChartColumn(context, AngerBarChart(pointData: angerDateList,), AngerLineChart(pointData: angerDataList,)),
              ChartColumn(context, SadnessBarChart(pointData: sadnessDateList,), SadnessLineChart(pointData: sadnessDataList,))
            ],
          ),
        ),
      ],
    );
  }

  Widget ChartColumn(BuildContext context,Widget topWidget,Widget bottomWidget){
    return Column(
      children: <Widget>[
        Container(
            height: 200,
            width: MediaQuery.of(context).size.width - 32,
            child: topWidget
        ),
        Container(
            height: 200,
            width: MediaQuery.of(context).size.width - 32,
            child: bottomWidget
        ),
      ],
    );
  }

}