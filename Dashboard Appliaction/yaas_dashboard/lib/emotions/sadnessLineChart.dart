import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';
import 'package:yaas_dashboard/emotions/emotionsGenericStorage.dart';

class SadnessLineChart extends StatelessWidget{
  final List<EmotionLineDataSeries> pointData;
  const SadnessLineChart({@required this.pointData});

  @override
  Widget build(BuildContext context) {
    return EmotionGenericLineChart(label: "Sadness Score per Message", pointData: pointData, isAnimated: true, emotionColor: AppColors["Blue"], cardColor: AppColors["BlueChartBackgroundColor"]);
  }
}