import 'dart:math';

import 'package:balikavi/models/WeatherModelGfs.dart';
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
  static const nightBgLink = "https://i.hizliresim.com/42n6z1e.png";
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
      double rh =  weatherModelGfs.rhSurface![i];
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
                  Text(rh.round().toString()+"%",style: TextStyle(color: Colors.grey),)
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



}