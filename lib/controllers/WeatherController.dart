import 'dart:convert';
import 'dart:math';

import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/models/PositionsModel.dart';
import 'package:balikavi/models/SunSetAndRiseModel.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/utils/Links.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../models/WeatherModelGfs.dart';

class WeatherController extends GetxController{

  static WeatherController instance = Get.find();

  var weatherModelGfs = <WeatherModelGfs>[].obs;
  var sunSetRiseModel = <SunSetAndRiseModel>[].obs;

  var requestDate = DateTime.now().obs;

  var searchResult = RxList();

  var addedLoading = false.obs;

  WeatherController();

  Future getWeatherData({PositionsModel? posModel})async{
    if(posModel != null){
      var baseData = {
        "key": Links.weatherApiKey,
        "lat": posModel.latitude,
        "lon": posModel.longitude,
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
      var responseSunSetRise = await MainController.instance.dio.get(Links.sunSetRiseApi(posModel.latitude!,posModel.longitude!));
      var responsed = SunSetAndRiseModel.fromJson(responseSunSetRise.data["results"]);
      sunSetRiseModel.value.add(responsed);
      sunSetRiseModel.refresh();
      weatherModelGfs.value.add(responsesConvData);
      weatherModelGfs.refresh();
      requestDate.value = DateTime.now();
      MainController.instance.loadData.value = true;
      MainController.instance.loadData.refresh();

    }
    else{
      weatherModelGfs.clear();
      MainController.instance.loadData.value = false;
      MainController.instance.loadData.refresh();
      for (var posModel in MainController.instance.appSettings.value.positions!) {
        var baseData = {
          "key": Links.weatherApiKey,
          "lat": posModel.latitude,
          "lon": posModel.longitude,
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
        var responseSunSetRise = await MainController.instance.dio.get(Links.sunSetRiseApi(posModel.latitude!,posModel.longitude!));
        var responsed = SunSetAndRiseModel.fromJson(responseSunSetRise.data["results"]);
        sunSetRiseModel.value.add(responsed);
        sunSetRiseModel.refresh();
        weatherModelGfs.value.add(responsesConvData);
        weatherModelGfs.refresh();

      }
      requestDate.value = DateTime.now();
      MainController.instance.loadData.value = true;
      MainController.instance.loadData.refresh();
    }
  }

  Future refreshWeatherData()async{
    for (int i = 0; i < MainController.instance.appSettings.value.positions!.length;i++) {
      var baseData = {
        "key": Links.weatherApiKey,
        "lat": MainController.instance.appSettings.value.positions![i].latitude,
        "lon": MainController.instance.appSettings.value.positions![i].longitude,
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
      var responseSunSetRise = await MainController.instance.dio.get(Links.sunSetRiseApi(MainController.instance.appSettings.value.positions![i].latitude!,MainController.instance.appSettings.value.positions![i].longitude!));
      var responsed = SunSetAndRiseModel.fromJson(responseSunSetRise.data["results"]);
      weatherModelGfs.value[i] = responsesConvData;
      sunSetRiseModel.value[i] = responsed;
      sunSetRiseModel.refresh();
      weatherModelGfs.refresh();
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
      addedLoading.value = true;
      addedLoading.refresh();
      Get.back();
      MainController.instance.appSettings.value.positions!.add(positionsModel);
      MainController.instance.appSettings.refresh();
      MainController.instance.setSettings();
      MainController.instance.getAddressFromLatLong(positionsModel);
      await getWeatherData(posModel: positionsModel);
      AppUtils.showNotification("Yer ekleme", "Konum eklendi");
      searchResult.clear();
      addedLoading.value = false;
      addedLoading.refresh();
    }
    else{
      AppUtils.showNotification("Yer ekleme", "Mevcut konum zaten ekli");
    }
  }

  Future dellDbLatLong(int pos,PositionsModel positionsModel,Placemark placemark) async{
    WeatherController.instance.weatherModelGfs.value.remove(WeatherController.instance.weatherModelGfs.value[pos]);
    WeatherController.instance.weatherModelGfs.refresh();
    MainController.instance.appSettings.value.positions!.remove(positionsModel);
    MainController.instance.placesData.value.remove(placemark);
    MainController.instance.placesData.refresh();
    MainController.instance.appSettings.refresh();
    MainController.instance.setSettings();
    AppUtils.showNotification("Yer silme", "Konum Silindi");
  }

  int getFeelsLikeTemperature(double temp,double humidity){
    var ets = pow(10, (-2937.4 / temp) - 4.9283 * log(temp) / ln10 + 23.5471);
    var etd = ets * humidity / 100;
    var hx = temp + ((etd - 10) *5/9);
    var x = hx.roundToDouble();
    return (x - 273).round();
  }

}