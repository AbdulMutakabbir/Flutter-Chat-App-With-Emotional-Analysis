import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';
import 'package:yaas_dashboard/emotions/emotionsGenericDateStorage.dart';

class AngerBarChart extends StatelessWidget{
  final List<EmotionBarDataSeries> pointData;

  const AngerBarChart({@required this.pointData});

  @override
  Widget build(BuildContext context) {
    return EmotionGenericBarChart(pointData: pointData, isAnimated: true, title: "Anger Score pre Day", emotionColor: AppColors["RedChartColor"], titleColor: AppColors["Red"]);
  }
}