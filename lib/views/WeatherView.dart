import 'dart:math';

import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/widgets/FirstSectionWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:line_icons/line_icon.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        leading: IconButton(icon: const Icon(Icons.menu),onPressed: (){}),
      ),
      body:Obx(()=>Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(AppUtils.nightBgLink!),
              fit: BoxFit.cover
          ),
        ),
        child:RefreshIndicator(
          onRefresh: ()async{await WeatherController.instance.getWeatherData();},
          child: ListView.builder(
            itemCount: WeatherController.instance.weatherModelGfs.value.length,
            itemBuilder: (_,int pos){
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
                    Text("${MainController.instance.placesData.value[pos].street!} / ${MainController.instance.placesData.value[pos].administrativeArea!}",style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(Jiffy(WeatherController.instance.requestDate.value).yMMMMdjm.toString(),style: TextStyle(color: Colors.grey),),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            AppUtils.getTypeWeather(WeatherController.instance.weatherModelGfs.value[pos].ptypeSurface!.last),
                            const SizedBox(width: 10),
                            Text(AppUtils.getCelsiusText(AppUtils.todayLastForecast(WeatherController.instance.weatherModelGfs.value[pos])),style: TextStyle(fontSize: 40),)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${AppUtils.getCelsiusText(AppUtils.todayFirstAndLastForecast(WeatherController.instance.weatherModelGfs.value[pos]).first)} / ${AppUtils.getCelsiusText(AppUtils.todayFirstAndLastForecast(WeatherController.instance.weatherModelGfs.value[pos]).last)}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                            Text("Hissedilen Sıcaklık: ${WeatherController.instance.getFeelsLikeTemperature(AppUtils.todayLastForecast(WeatherController.instance.weatherModelGfs.value[pos]), AppUtils.todayLastHumidity(WeatherController.instance.weatherModelGfs.value[pos]))}${AppUtils.celsiusIconText}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: AppUtils.hoursWeatherWidgets(WeatherController.instance.weatherModelGfs.value[pos]),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          ),
        ),
      )
    );
  }






}
