import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/utils/Links.dart';
import 'package:get/get.dart';

class WeatherController extends GetxController{

  static WeatherController instance = Get.find();

  WeatherController(){
    getWeatherData();
  }

  Future getWeatherData()async{
    var data = {
      "key": Links.weatherApiKey,
      "lat": MainController.instance.myPosition.value.latitude,
      "lon": MainController.instance.myPosition.value.longitude,
      "levels": [
        "surface",
        "800h",
        "300h",
      ],
      "model": "gfs",
      "parameters": [
        "wind",
        "dewpoint",
        "rh",
        "pressure",
        "temp"
      ]
    };
    var response = await MainController.instance.dio.post(Links.weatherApi,data: data);
    print(response.data);
  }

}