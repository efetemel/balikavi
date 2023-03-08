import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/utils/Links.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/WeatherModelGfs.dart';

class WeatherController extends GetxController{

  static WeatherController instance = Get.find();

  var weatherModelGfs = WeatherModelGfs().obs;

  var firstRequest = true.obs;
  var requestDate = DateTime.now().obs;

  WeatherController(){
    getWeatherData();
  }

  Future getWeatherData()async{
    if(firstRequest.value || requestDate.value.add(Duration(minutes: 30)) == DateTime.now()){
      firstRequest.value = false;
      var baseData = {
        "key": Links.weatherApiKey,
        "lat": MainController.instance.myPosition.value.latitude,
        "lon": MainController.instance.myPosition.value.longitude,
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

      try{
        var responseGfs = await MainController.instance.dio.post(Links.weatherApi,data: dataGfs);
        var responseGfsWave = await MainController.instance.dio.post(Links.weatherApi,data: dataGfsWave);
        weatherModelGfs.value = WeatherModelGfs.fromJson(responseGfs.data);
        weatherModelGfs.refresh();
        requestDate.value = DateTime.now();
      }catch(err){
        if(err is DioError){
          AppUtils.showNotification("Sistem bilgisi", "Konum veya İnternet açık değil!");
        }
      }
    }
    else{
      // 30 DAKİKA SONRA GEL
    }
  }

}