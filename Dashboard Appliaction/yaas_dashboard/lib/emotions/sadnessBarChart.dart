import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';
import 'package:yaas_dashboard/emotions/emotionsGenericDateStorage.dart';

class SadnessBarChart extends StatelessWidget{
  final List<EmotionBarDataSeries> pointData;

  const SadnessBarChart({@required this.pointData});

  @override
  Widget build(BuildContext context) {
    return EmotionGenericBarChart(pointData: pointData, isAnimated: true, title: "Sadness Score pre Day", emotionColor: AppColors["BlueChartColor"], titleColor: AppColors["Blue"]);
  }
}