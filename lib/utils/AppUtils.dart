import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class AppUtils{
  static var appName = "Balık Avı";
  static var appLanguageShort = "tr";
  static var bottomIcons = [LineIcons.fish,Icons.sunny,Icons.search,Icons.settings,Icons.person];
  static var theme = ThemeData.dark().copyWith(useMaterial3: true,scaffoldBackgroundColor: const Color.fromRGBO(28, 28, 28, 1));

  static final Random _rnd = Random.secure();
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) =>
          _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static void showNotification(String title,String message,{IconData icon = Icons.notifications}){
    Get.snackbar(title, message,icon: Icon(icon),snackPosition: SnackPosition.TOP);
  }
}