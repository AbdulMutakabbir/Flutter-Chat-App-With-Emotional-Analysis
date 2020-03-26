import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';
import 'package:yaas_dashboard/emotions/emotionsGenericDateStorage.dart';

class JoyBarChart extends StatelessWidget{
  final List<EmotionBarDataSeries> pointData;

  const JoyBarChart({@required this.pointData});

  @override
  Widget build(BuildContext context) {
    return EmotionGenericBarChart(pointData: pointData, isAnimated: true, title: "Happiness Score pre Day", emotionColor: AppColors["AmberChartColor"], titleColor: AppColors["Amber"]);
  }
}