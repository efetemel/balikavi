import 'dart:math';

import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/models/WeatherModelGfs.dart';
import 'package:balikavi/views/FishView.dart';
import 'package:balikavi/views/LocationView.dart';
import 'package:balikavi/views/SettingsView.dart';
import 'package:balikavi/views/WeatherView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

import '../controllers/WeatherController.dart';

class AppUtils{
  static var appName = "Balık Avı";
  static var appLanguageShort = "tr";
  static var kelvinToCelsius = 273.15;
  static var celsiusIconText = "°c";
  static var bottomIcons = [LineIcons.fish,Icons.sunny,Icons.search,Icons.settings,Icons.person];
  static const boxNightColor = Color.fromRGBO(52, 52, 52, 1);
  static const bottomNavNightColor = Color.fromRGBO(0, 0, 0, 0.45);
  static const bgDecoration = BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assets/images/bg.jpg"),
        fit: BoxFit.cover
    ),
  );
  static final Random _rnd = Random.secure();
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) =>
          _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static void showNotification(String title,String message,{IconData icon = Icons.notifications}){
    Get.snackbar(title, message,icon: Icon(icon),snackPosition: SnackPosition.TOP);
  }

  static String getCelsiusText(double kelvin){
    return (kelvin - kelvinToCelsius).floor().toString() + celsiusIconText;
  }

  static double todayLastForecast(WeatherModelGfs weatherModelGfs) {
    var todayWeathers = <double>[];
    var response = 0.0;

    for (int i = 0; i <
        weatherModelGfs.tempSurface!
            .length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(weatherModelGfs.ts![i]);
      if(date.day == DateTime.now().day){
        todayWeathers.add(weatherModelGfs.tempSurface![i]);
      }
    }
    for (var element in todayWeathers) {
      response += element;
    }
    return response / todayWeathers.length;
  }

  static double todayLastHumidity(WeatherModelGfs weatherModelGfs) {
    var todayWeathers = <double>[];
    var response = 0.0;

    for (int i = 0; i <
        weatherModelGfs.tempSurface!
            .length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(weatherModelGfs.ts![i]);
      if(date.day == DateTime.now().day){
        todayWeathers.add(weatherModelGfs.rhSurface![i]);
      }
    }
    for (var element in todayWeathers) {
      response += element;
    }
    return response / todayWeathers.length;
  }

  static double todayLastWindU(WeatherModelGfs weatherModelGfs) {
    var todayWeathers = <double>[];
    var response = 0.0;

    for (int i = 0; i <
        weatherModelGfs.tempSurface!
            .length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(weatherModelGfs.ts![i]);
      if(date.day == DateTime.now().day){
        todayWeathers.add(weatherModelGfs.windUSurface![i]);
      }
    }
    for (var element in todayWeathers) {
      response += element;
    }
    return response / todayWeathers.length;
  }
  static double todayLastWindV(WeatherModelGfs weatherModelGfs) {
    var todayWeathers = <double>[];
    var response = 0.0;

    for (int i = 0; i <
        weatherModelGfs.tempSurface!
            .length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(weatherModelGfs.ts![i]);
      if(date.day == DateTime.now().day){
        todayWeathers.add(weatherModelGfs.windVSurface![i]);
      }
    }
    for (var element in todayWeathers) {
      response += element;
    }
    return response / todayWeathers.length;
  }

  static int todayLastPressure(WeatherModelGfs weatherModelGfs) {
    var todayWeathers = <double>[];
    var response = 0.0;
    double standartBasincPa = 101325.0; // Standart atmosfer basıncı, Pa cinsinden

    for (int i = 0; i <
        weatherModelGfs.tempSurface!
            .length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(weatherModelGfs.ts![i]);
      if(date.day == DateTime.now().day){
        todayWeathers.add(weatherModelGfs.pressureSurface![i]);
      }
    }
    for (var element in todayWeathers) {
      response += element;
    }
    var h = response / todayWeathers.length;
    double resPressure = (h / standartBasincPa) * 100.0; // Basıncın yüzdesi
    return resPressure.floor();
  }


  static int xtodayLastHumidity(WeatherModelGfs weatherModelGfs,int pos) {
    var todayWeathers = <double>[];
    var response = 0.0;
    var time = [];
    for (int i = 0; i <
        weatherModelGfs.rhSurface!
            .length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(weatherModelGfs.ts![pos]);
      todayWeathers.add(weatherModelGfs.rhSurface![pos]);

    }
    for (var element in todayWeathers) {
      response += element;
    }
    return (response / todayWeathers.length).toInt();
    //BURDA KALDIN "(
  }

  static List<double> todayFirstAndLastForecast(WeatherModelGfs weatherModelGfs) {
    var todayWeathers = <double>[];

    for (int i = 0; i <
        weatherModelGfs.tempSurface!
            .length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(weatherModelGfs.ts![i]);
      if(date.day == DateTime.now().day){
        todayWeathers.add(weatherModelGfs.tempSurface![i]);
      }
    }
    return [todayWeathers.first,todayWeathers.last];
  }


  static List<Widget> hoursWeatherWidgets(WeatherModelGfs weatherModelGfs){
    List<Widget> x = [];
    for (var i =  0; i < weatherModelGfs.ts!.length.toInt(); i++) {
      var weatherDateTime = DateTime.fromMillisecondsSinceEpoch(weatherModelGfs.ts![i]);
      var dateTimeNow = DateTime.now();
      var rh =  weatherModelGfs.rhSurface![i];
      if((weatherDateTime.day == dateTimeNow.day || weatherDateTime.day == dateTimeNow.day+1 )&& (weatherDateTime.month == dateTimeNow.month)){
        x.add( Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Text(Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherModelGfs.ts![i])).jm.toString(),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              getTypeWeather(weatherModelGfs.ptypeSurface![i]),
              SizedBox(height: 5),
              Text(AppUtils.getCelsiusText(weatherModelGfs.tempSurface![i]),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Row(
                children: [
                  Icon(Icons.water_drop,size: 12,),
                  SizedBox(width: 3),
                  Text("%${rh.round()}",style: TextStyle(color: Colors.grey),)
                ],
              )
            ],
          ),
        ));

      }
      else{
      }
    }
    return x;
  }

  static Icon getTypeWeather(int ptypeSurface,{double iconSize = 40}){
    switch(ptypeSurface){
      case 0:
        return Icon(Icons.cloud,size: iconSize);
      case 1:
        return LineIcon.cloudWithRain(size: iconSize);
      case 3:
        return Icon(Icons.add,size: iconSize);
      case 5:
        return Icon(Icons.cloudy_snowing,size: iconSize);
      case 8:
        return Icon(Icons.ice_skating,size: iconSize);
      default:
        return Icon(Icons.cloud,size: iconSize);
    }
  }

  static IconButton getMenu(){
    return IconButton(onPressed: (){
      MainController.instance.scaffoldKey.value.currentState!.openDrawer();
    },icon: Icon(Icons.menu));
  }


}