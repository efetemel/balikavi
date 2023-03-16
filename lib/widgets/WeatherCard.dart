import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../controllers/MainController.dart';
import '../controllers/WeatherController.dart';
import '../utils/AppUtils.dart';

class WeatherCard extends StatelessWidget {
  int pos;

  WeatherCard(this.pos, {super.key});

  @override
  Widget build(BuildContext context) {
    var weatherController = WeatherController.instance;
    var mainController = MainController.instance;
    var weatherModel = WeatherController.instance.weatherModelGfs.value.reversed.toList()[pos];
    var placesData = MainController.instance.placesData.value.reversed.toList()[pos];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppUtils.boxNightColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${placesData.subLocality!} / ${placesData.administrativeArea!}",style: TextStyle(fontWeight: FontWeight.bold),),
          Text(Jiffy(weatherController.requestDate.value).yMMMMdjm.toString(),style: TextStyle(color: Colors.grey),),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppUtils.getTypeWeather(weatherModel.ptypeSurface!.last),
                  const SizedBox(width: 10),
                  Text(AppUtils.getCelsiusText(AppUtils.todayLastForecast(weatherModel)),style: TextStyle(fontSize: 40),)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${AppUtils.getCelsiusText(AppUtils.todayFirstAndLastForecast(weatherModel).first)} / ${AppUtils.getCelsiusText(AppUtils.todayFirstAndLastForecast(weatherModel).last)}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                  Text("Hissedilen Sıcaklık: ${weatherController.getFeelsLikeTemperature(AppUtils.todayLastForecast(weatherModel), AppUtils.todayLastHumidity(weatherModel))}${AppUtils.celsiusIconText}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppUtils.hoursWeatherWidgets(weatherModel),
            ),
          )
        ],
      ),
    );
  }
}
