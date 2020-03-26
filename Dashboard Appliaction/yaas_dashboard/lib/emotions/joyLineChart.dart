import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';
import 'package:yaas_dashboard/emotions/emotionsGenericStorage.dart';

class JoyLineChart extends StatelessWidget{
  final List<EmotionLineDataSeries> pointData;
  const JoyLineChart({@required this.pointData});

  @override
  Widget build(BuildContext context) {
    return EmotionGenericLineChart(label: "Happiness Score per Message", pointData: pointData, isAnimated: true, emotionColor: AppColors["Amber"], cardColor: AppColors["AmberChartBackgroundColor"]);
  }
}