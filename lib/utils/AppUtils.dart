import 'dart:math';

import 'package:balikavi/models/AppThemeModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class AppUtils{
  static var appName = "Balık Avı";
  static var appLanguageShort = "tr";
  static var kelvinToCelsius = 273.15;
  static var celsiusIconText = "°c";
  static var bottomIcons = [LineIcons.fish,Icons.sunny,Icons.search,Icons.settings,Icons.person];
  static const _boxNightColor = Color.fromRGBO(52, 52, 52, 1);
  static const _bottomNavNightColor = Color.fromRGBO(0, 0, 0, 0.45);
  static const _bottomNavDayColor = Color.fromRGBO(0, 0, 0, 0.45);
  static const _nightBgLink = "https://i.hizliresim.com/42n6z1e.png";
  static const _dayBgLink = "https://i.hizliresim.com/3a5d5gi.png";
  static final _boxDayColor = Color.fromRGBO(80, 80, 80, 1);
  static final Random _rnd = Random.secure();
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static var nightTheme = AppThemeModel(boxColor: _boxNightColor,backgroundImage: _nightBgLink,bottomNavColor: _bottomNavNightColor);
  static var dayTheme = AppThemeModel(boxColor: _boxDayColor,backgroundImage: _dayBgLink,bottomNavColor: _bottomNavDayColor);


  static AppThemeModel getTheme(){
    var whiteHours = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,18];
    var response = AppThemeModel();
    whiteHours.forEach((element) {
      if(DateTime.now().hour == element){
        response = dayTheme;
      }
      else{
        response = nightTheme;
      }
    });
    return response;
  }

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) =>
          _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static void showNotification(String title,String message,{IconData icon = Icons.notifications}){
    Get.snackbar(title, message,icon: Icon(icon),snackPosition: SnackPosition.TOP);
  }

  static String getCelsiusText(double kelvin){
    return (kelvin - kelvinToCelsius).floor().toString() + celsiusIconText;
  }


}