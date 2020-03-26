import 'package:flutter/material.dart';
import 'package:yaas_dashboard/Colors/colorsMap.dart';

Widget BasicAppBar() {
  return AppBar(
    backgroundColor: AppColors["AppColor"],
    title: Text(
      'Dashboard',
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget AppBarWithAction(List<Widget> actions) {
  return AppBar(
    backgroundColor: Color.fromRGBO(115, 40, 182, 1),
    actions: actions,
    title: Text(
      'Dashboard',
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget PHQ9Info(){
  return IconButton(
    icon: Icon(Icons.info_outline,color: AppColors["White"])
  );
}

Widget Logout(){
  return IconButton(
    icon: Icon(Icons.power_settings_new,color: AppColors["White"],),
  );
}