import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    var mounths = [];


    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        leading: IconButton(icon: Icon(Icons.menu),onPressed: (){}),
      ),
      body:Obx(()=>Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(MainController.instance.appTheme.value.backgroundImage!),
              fit: BoxFit.cover
          ),
        ),
        child:RefreshIndicator(
          onRefresh: ()async{await WeatherController.instance.getWeatherData();},
          child: ListView(
            children: [
              Container(
                height: 200,
                alignment: Alignment.center,
                child: Text("Hava Durumu",style: TextStyle(fontSize: 40),),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: MainController.instance.appTheme.value.boxColor!),
                    color: MainController.instance.appTheme.value.boxColor!
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(MainController.instance.placeData.value.street!,style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(Jiffy(DateTime.now()).yMMMMdjm.toString(),style: TextStyle(color: Colors.grey),),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cloudy_snowing,size: 48),
                            Text(AppUtils.getCelsiusText(todayLastForecast()),style: TextStyle(fontSize: 40),)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(test(),style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                            Text(AppUtils.getCelsiusText(todayFirstAndLastForecast().first) + " / " +AppUtils.getCelsiusText(todayFirstAndLastForecast().last),style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                            Text("Feels like 8"+AppUtils.celsiusIconText,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: hoursWeatherWidgets(),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Color.fromRGBO(52, 52, 52, 0.6)),
                    color: Color.fromRGBO(52, 52, 52, 1)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(MainController.instance.placeData.value.street!,style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(Jiffy(WeatherController.instance.requestDate.value).yMMMMdjm.toString(),style: TextStyle(color: Colors.grey),),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cloudy_snowing,size: 48),
                            Text(AppUtils.getCelsiusText(todayLastForecast()),style: TextStyle(fontSize: 40),)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(test(),style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                            Text(AppUtils.getCelsiusText(todayFirstAndLastForecast().first) + " / " +AppUtils.getCelsiusText(todayFirstAndLastForecast().last),style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                            Text("Feels like 8"+AppUtils.celsiusIconText,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: hoursWeatherWidgets(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ))
    );
  }
  
  double todayLastForecast() {
    var todayWeathers = <double>[];
    var response = 0.0;

    for (int i = 0; i <
        WeatherController.instance.weatherModelGfs.value.tempSurface!
            .length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![i]);
        if(date.day == DateTime.now().day){
          todayWeathers.add(WeatherController.instance.weatherModelGfs.value.tempSurface![i]);
        }
    }
    for (var element in todayWeathers) {
      response += element;
    }
    return response / todayWeathers.length;
  }

  List<double> todayFirstAndLastForecast() {
    var todayWeathers = <double>[];

    for (int i = 0; i <
        WeatherController.instance.weatherModelGfs.value.tempSurface!
            .length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![i]);
        if(date.day == DateTime.now().day){
          todayWeathers.add(WeatherController.instance.weatherModelGfs.value.tempSurface![i]);
        }
    }
    return [todayWeathers.first,todayWeathers.last];
  }

  List<Widget> hoursWeatherWidgets(){
    List<Widget> x = [];
    for (var i =  0; i < WeatherController.instance.weatherModelGfs.value.ts!.length.toInt(); i++) {
      var weatherDateTime = DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![i]);
      var dateTimeNow = DateTime.now();
      if((weatherDateTime.day == dateTimeNow.day || weatherDateTime.day == dateTimeNow.day+1 )&& (weatherDateTime.month == dateTimeNow.month)){
        x.add( Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Text(Jiffy(DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![i])).jm.toString(),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Icon(Icons.cloudy_snowing),
              SizedBox(height: 5),
              Text(AppUtils.getCelsiusText(WeatherController.instance.weatherModelGfs.value.tempSurface![i]),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Row(
                children: [
                  Icon(Icons.water_drop,size: 12,),
                  SizedBox(width: 3),
                  Text("30%",style: TextStyle(color: Colors.grey),)
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

  String test(){
    var t = "";
    var typeList = [];
    for (int i = 0; i <
        WeatherController.instance.weatherModelGfs.value.tempSurface!
            .length; i++) {
      var date = DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![i]);
      if(date.day == DateTime.now().day){
        print(WeatherController.instance.weatherModelGfs.value.ptypeSurface![i]);
        typeList.add(WeatherController.instance.weatherModelGfs.value.ptypeSurface![i]);
      }
    }

    return t;
  }

}
