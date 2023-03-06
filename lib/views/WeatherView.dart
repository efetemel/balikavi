import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    const String link = "https://i.hizliresim.com/3a5d5gi.png";
    const String countryName = "İstanbul";

    var days = [];


     /*if(WeatherController.instance.weatherModelGfs.value.tempSurface != null){
        for (var i = 0; i < WeatherController.instance.weatherModelGfs.value.tempSurface!.length.toInt(); i++) {
          double celsius = (WeatherController.instance.weatherModelGfs.value.tempSurface![i] - 273.15);
          print("Derece : ${celsius.floorToDouble()}, Zaman : ${Jiffy(DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![i])).yMMMMdjm}");
          print("DewPoint : "+WeatherController.instance.weatherModelGfs.value.dewpointSurface![i].toString());
        }
      }*/

    double celsius = WeatherController.instance.weatherModelGfs.value.tempSurface![0] - AppUtils.kelvinToCelsius;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body:Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(link),
            fit: BoxFit.cover
          ),
        ),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(countryName,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold)),
                Text(celsius.floor().toString()+AppUtils.celsiusIconText,style: TextStyle(fontSize: 80)),
                Text("Güneşli",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                  color: const Color.fromRGBO(52, 52, 52, 0.3)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Hava durumu 3 saat aralıklarla belirlenir."),
                  Text("Bugün ve yarının saatlik bilgisi."),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
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
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                  color: const Color.fromRGBO(52, 52, 52, 0.3)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 5),
                      Text("10 - GÜNLÜK HAVA DURUMU")
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: WeatherController.instance.weatherModelGfs.value.ts!.length,
                        itemBuilder: (_,int pos){
                          var weatherDateTime = DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![pos]);
                          var dateTimeNow = DateTime.now();
                          if(!days.contains(Jiffy(weatherDateTime).EEEE)){
                            double _celsius = WeatherController.instance.weatherModelGfs.value.tempSurface![pos] - AppUtils.kelvinToCelsius;
                            days.add(Jiffy(weatherDateTime).EEEE.toString());
                            var dayName = "";
                            if(weatherDateTime.day == dateTimeNow.day){
                              dayName = "Bugün";
                            }
                            else if(weatherDateTime.day < dateTimeNow.day){
                              dayName = "Dün";
                            }
                            else {
                              dayName =  Jiffy(weatherDateTime).EEEE;
                            }
                            return ListTile(
                              title: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(dayName),
                                  ],
                                ),
                              ),
                              trailing: Text(_celsius.floor().toString()+AppUtils.celsiusIconText,style: TextStyle(fontWeight: FontWeight.bold),),
                            );
                          }
                          else{
                            return Container();
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  List<Widget> hoursWeatherWidgets(){
    List<Widget> x = [];
    for (var i =  0; i < WeatherController.instance.weatherModelGfs.value.ts!.length.toInt(); i++) {
      double celsius = WeatherController.instance.weatherModelGfs.value.tempSurface![i] - AppUtils.kelvinToCelsius;
      var weatherDateTime = DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![i]);
      var dateTimeNow = DateTime.now();
      if((weatherDateTime.day == dateTimeNow.day || weatherDateTime.day == dateTimeNow.day+1 )&& (weatherDateTime.month == dateTimeNow.month)){
        x.add( Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Text(Jiffy(DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![i])).jm.toString(),style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Icon(Icons.cloudy_snowing),
              SizedBox(height: 5),
              Text(celsius.floor().toString()+AppUtils.celsiusIconText,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ],
          ),
        ));

      }
      else{
      }
    }
    return x;
  }

}
