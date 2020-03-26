import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';

class EmotionSeries {
  final String emotion;
  final double value;
  final charts.Color color;

  EmotionSeries(
      {@required this.emotion, @required this.value, @required this.color});
}

class EmotionChart extends StatelessWidget {
  final List<EmotionSeries> pointData;
  final int durationSeconds;

  const EmotionChart({@required this.pointData, this.durationSeconds = 2});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<EmotionSeries, String>> series = [
      charts.Series(
        id: "Emotion Data",
        data: pointData,
        domainFn: (EmotionSeries series, _) => series.emotion,
        measureFn: (EmotionSeries series, _) => series.value,
        colorFn: (EmotionSeries series, _) => series.color,
        labelAccessorFn: (EmotionSeries series, _) => "${series.emotion}: ",
      )
    ];

    return Column(
      children: <Widget>[
        Text("Emotion Data for conversations.",
          style: TextStyle(
            color: Color.fromRGBO(115, 40, 182, 1),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: charts.PieChart(
                  series,
                  animate: true,
                  animationDuration: Duration(seconds: durationSeconds),
                  defaultRenderer: charts.ArcRendererConfig(
//            arcWidth: 50,
                      arcRendererDecorators: [charts.ArcLabelDecorator()]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Label("Joy", AppColors["AmberChartColor"]),
                    Label("Anger", AppColors["RedChartColor"]),
                    Label("Sadness", AppColors["BlueChartColor"])
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget Label(String _label,Color _color){
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: SizedBox(
            width: 10,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: _color
              ),
            ),
          ),
        ),
        Text(_label,),
      ],
    );
  }
}
