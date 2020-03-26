
import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';
import 'package:yaas_dashboard/patients.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        primarySwatch: AppColors["Blue"],
      ),
      home: Patients(),
    );
  }
}
