import 'dart:convert';
import 'dart:math';

import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/models/PositionsModel.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/utils/Links.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/WeatherModelGfs.dart';

class WeatherController extends GetxController{

  static WeatherController instance = Get.find();

  var weatherModelGfs = <WeatherModelGfs>[].obs;

  var requestDate = DateTime.now().obs;

  var searchResult = RxList();

  WeatherController(){
  }

  Future getWeatherData()async{
    try{
      print("çağrıyorum");
      weatherModelGfs.clear();
      for (var element in MainController.instance.appSettings.value.positions!) {
        var baseData = {
          "key": Links.weatherApiKey,
          "lat": element.latitude,
          "lon": element.longitude,
          "levels": [
            "surface",
            "800h",
            "300h",
          ]
        };
        var dataGfs = {
          ...baseData,
          "model": "gfs",
          "parameters": [
            "wind",
            "windGust",
            "dewpoint",
            "pressure",
            "temp",
            "precip",
            "convPrecip",
            "lclouds",
            "mclouds",
            "hclouds",
            "ptype",
            "cape",
            "rh",
            "gh"
          ]
        };
        var dataGfsWave = {
          ...baseData,
          "model": "gfsWave",
          "parameters": [
            "waves",
            "windWaves",
            "swell1",
            "swell2"
          ]
        };
        var responseGfs = await MainController.instance.dio.post(Links.weatherApi,data: dataGfs);
        var responseGfsWave = await MainController.instance.dio.post(Links.weatherApi,data: dataGfsWave);
        var responsesConvData = WeatherModelGfs.fromJson(responseGfs.data);
        weatherModelGfs.value.add(responsesConvData);
        weatherModelGfs.refresh();
      }
      requestDate.value = DateTime.now();
    }catch(err){
      print(err);
      if(err is DioError){
        AppUtils.showNotification("Sistem bilgisi", "Konum veya İnternet açık değil!");
      }
    }
    if(requestDate.value.add(Duration(minutes: 30)) == DateTime.now()){

    }
    else{
      // 30 DAKİKA SONRA GEL
    }
  }

  Future searchLocation(String query)async{
    if(query.isNotEmpty){
      var responseQuery = await MainController.instance.dio.get(Links.googleSearchApi + query);
      var response = responseQuery.data["results"] as List<dynamic>;
      searchResult.value = response;
      searchResult.refresh();
    }
  }

  Future addDBLatLong(PositionsModel positionsModel) async{
    if(MainController.instance.appSettings.value.positions!.contains(positionsModel) == false){
      MainController.instance.appSettings.value.positions!.add(positionsModel);
      MainController.instance.appSettings.refresh();
      MainController.instance.setSettings();
      AppUtils.showNotification("Yer ekleme", "Konum eklendi");
      searchResult.clear();
    }
    else{
      AppUtils.showNotification("Yer ekleme", "Mevcut konum zaten ekli");
    }
  }

  int getFeelsLikeTemperature(double temp,double humidity){
    var ets = pow(10, (-2937.4 / temp) - 4.9283 * log(temp) / ln10 + 23.5471);
    var etd = ets * humidity / 100;
    var hx = temp + ((etd - 10) *5/9);
    var x = hx.roundToDouble();
    return (x - 273).round();
  }

}