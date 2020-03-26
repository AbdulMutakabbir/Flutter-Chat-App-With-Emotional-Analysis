import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';
import 'package:yaas_dashboard/emotions/emotionsGenericStorage.dart';

class AngerLineChart extends StatelessWidget{
  final List<EmotionLineDataSeries> pointData;
  const AngerLineChart({@required this.pointData});

  @override
  Widget build(BuildContext context) {
    return EmotionGenericLineChart(label: "Anger Score per Message", pointData: pointData, isAnimated: true, emotionColor: AppColors["Red"], cardColor: AppColors["RedChartBackgroundColor"]);
  }
}