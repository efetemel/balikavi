import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {


    /*if(WeatherController.instance.weatherModelGfs.value.tempSurface != null){
      for (var i = 0; i < WeatherController.instance.weatherModelGfs.value.tempSurface!.length.toInt(); i++) {
        double celsius = (WeatherController.instance.weatherModelGfs.value.tempSurface![i] - 273.15);
        print("Derece : ${celsius.floorToDouble()}, Zaman : ${Jiffy(DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![i])).yMMMMdjm}");
        print("DewPoint : "+WeatherController.instance.weatherModelGfs.value.dewpointSurface![i].toString());
      }
    }*/

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child:RefreshIndicator(
            onRefresh: ()async{
              await WeatherController.instance.getWeatherData();
            },
            child: ListView.builder(
              itemCount: WeatherController.instance.weatherModelGfs.value.ts!.length,
              itemBuilder: (_,int pos){
                double celsius = (WeatherController.instance.weatherModelGfs.value.tempSurface![pos] - AppUtils.kelvinToCelsius);
                return ListTile(
                  leading: Text(Jiffy(DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![pos])).yMMMMdjm),
                  title: Text(celsius.floor().toString()+AppUtils.celsiusIconText,style: TextStyle(fontWeight: FontWeight.bold),),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
