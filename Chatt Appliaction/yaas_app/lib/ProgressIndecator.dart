import 'package:flutter/material.dart';

class ProgressIndecator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    print("progress bar");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(115, 40, 182, 1),
        title: Text('YAAS App',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }

}