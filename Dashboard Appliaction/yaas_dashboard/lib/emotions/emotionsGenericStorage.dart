import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class EmotionLineDataSeries {
  final double value;
  final int counter;

  EmotionLineDataSeries({@required this.value,@required this.counter,});

}

class EmotionGenericLineChart extends StatelessWidget{
  final List<EmotionLineDataSeries> pointData;
  final bool isAnimated;
  final int durationSeconds;

  final String label;

  final Color cardColor;
  final Color emotionColor;

  const EmotionGenericLineChart({@required this.label, @required this.pointData,@required this.isAnimated, @required this.emotionColor, @required this.cardColor, this.durationSeconds = 1, });

  @override
  Widget build(BuildContext context) {
    List<charts.Series<EmotionLineDataSeries, int>> pointSeries = [
      charts.Series(
        id: label,
        data: pointData,
        domainFn: (EmotionLineDataSeries series, _) => series.counter,
        measureFn: (EmotionLineDataSeries series, _) => series.value,
        colorFn: (EmotionLineDataSeries series,_) => charts.ColorUtil.fromDartColor(emotionColor),
//        labelAccessorFn: (JoySeries series,_) => "${series.emotion}: ",
      )
    ];
    return Card(
      elevation: 3,
      color: cardColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(label,
              style: TextStyle(
                  color: emotionColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),),
          ),
          Expanded(
            child: charts.LineChart(pointSeries,
                animate: isAnimated,
                animationDuration: Duration(seconds: durationSeconds),
                defaultRenderer: charts.LineRendererConfig(strokeWidthPx: 2,radiusPx: 5,includePoints: true)),
          ),
        ],
      ),
    );
  }
}