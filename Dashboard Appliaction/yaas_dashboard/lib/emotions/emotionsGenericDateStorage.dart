import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class EmotionBarDataSeries {
  final double value;
  final DateTime date;

  EmotionBarDataSeries({@required this.value,@required this.date,});

}

class EmotionGenericBarChart extends StatelessWidget{
  final List<EmotionBarDataSeries> pointData;
  final bool isAnimated;
  final int durationSeconds;

  final Color emotionColor;
  final Color titleColor;

  final String title;

  const EmotionGenericBarChart({@required this.pointData,@required this.isAnimated, @required this.title, @required this.emotionColor, this.durationSeconds = 1, @required this.titleColor, });

  @override
  Widget build(BuildContext context) {
    List<charts.Series<EmotionBarDataSeries, String>> pointSeries = [
      charts.Series(
        id: title,
        data: pointData,
        domainFn: (EmotionBarDataSeries series, _) => formatDate(series.date, [dd,"-",mm,"-","yyyy"]),
        measureFn: (EmotionBarDataSeries series, _) => series.value,
        colorFn: (EmotionBarDataSeries series,_) => charts.ColorUtil.fromDartColor(emotionColor),
//        labelAccessorFn: (JoySeries series,_) => "${series.emotion}: ",
      )
    ];
    return Card(
      elevation: 3,
//      color: emotionColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),),
          ),
          Expanded(
            child: charts.BarChart(pointSeries,
              animate: isAnimated,
              animationDuration: Duration(seconds: durationSeconds),
//                defaultRenderer: charts.LineRendererConfig(strokeWidthPx: 2,radiusPx: 5,includePoints: true)
            ),
          ),
        ],
      ),
    );
  }
}