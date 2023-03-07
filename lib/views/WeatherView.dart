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

    const String link = "https://i.hizliresim.com/42n6z1e.png"; // Siyah
    //const String link = "https://i.hizliresim.com/3a5d5gi.png"; // Beyaz
    var mounths = [];


    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.menu),onPressed: (){}),
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
                  border: Border.all(color: Color.fromRGBO(52, 52, 52, 0.6)),
                  color: Color.fromRGBO(52, 52, 52, 1)
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
                          Text("10"+AppUtils.celsiusIconText,style: TextStyle(fontSize: 40),)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Ligth Rain Shower",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
                          Text("13"+AppUtils.celsiusIconText,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey),),
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
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Color.fromRGBO(52, 52, 52, 0.6)),
                  color: Color.fromRGBO(52, 52, 52, 1)
              ),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: 180,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: WeatherController.instance.weatherModelGfs.value.ts!.length,
                    itemBuilder: (_,int pos){
                      var weatherDateTime = DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![pos]);
                      var dateTimeNow = DateTime.now();
                      if(!mounths.contains(Jiffy(weatherDateTime).yMMMMd)){
                        double _celsius = WeatherController.instance.weatherModelGfs.value.tempSurface![pos] - AppUtils.kelvinToCelsius;
                        mounths.add(Jiffy(weatherDateTime).yMMMMd.toString());
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
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width:70,
                                child: Text(dayName,style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.water_drop,size: 12,),
                                    SizedBox(width: 3),
                                    Text("30%",style: TextStyle(color: Colors.grey),),
                                    SizedBox(width: 3),
                                    Icon(Icons.cloudy_snowing,size: 20,),
                                    SizedBox(width: 3),
                                    Icon(Icons.cloudy_snowing,size: 20,),
                                  ],
                                ),
                              ),
                              Container(
                                width: 30,
                                child:  Text(_celsius.floor().toString()+AppUtils.celsiusIconText,style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            )
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
              Text(Jiffy(DateTime.fromMillisecondsSinceEpoch(WeatherController.instance.weatherModelGfs.value.ts![i])).jm.toString(),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Icon(Icons.cloudy_snowing),
              SizedBox(height: 5),
              Text(celsius.floor().toString()+AppUtils.celsiusIconText,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
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



}
