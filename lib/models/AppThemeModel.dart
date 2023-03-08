import 'package:flutter/material.dart';

class AppThemeModel {
  Color? bottomNavColor;
  String? backgroundImage;
  Color? boxColor;

  AppThemeModel({this.bottomNavColor, this.backgroundImage, this.boxColor});

  AppThemeModel.fromJson(Map<String, dynamic> json) {
    bottomNavColor = json['bottomNavColor'];
    backgroundImage = json['backgroundImage'];
    boxColor = json['boxColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bottomNavColor'] = this.bottomNavColor;
    data['backgroundImage'] = this.backgroundImage;
    data['boxColor'] = this.boxColor;
    return data;
  }
}