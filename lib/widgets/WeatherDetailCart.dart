import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/models/WeatherModelGfs.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:line_icons/line_icon.dart';

class WeatherDetailCard extends StatelessWidget {
  WeatherModelGfs weatherModelGfs;

  WeatherDetailCard(this.weatherModelGfs, {super.key});
  var list = [].obs;
  var x = [].obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppUtils.boxNightColor),
      child: ListView.builder(
        itemCount: weatherModelGfs.tempSurface!.length,
        itemBuilder: (_, int pos) {
          var weatherDateTime =
              DateTime.fromMillisecondsSinceEpoch(weatherModelGfs.ts![pos]);
          var dateTimeNow = DateTime.now();
          if (!list.contains(Jiffy(weatherDateTime).yMMMMd)) {
            x.value.add(weatherModelGfs);
            double _celsius =
                weatherModelGfs.tempSurface![pos];
            list.add(Jiffy(weatherDateTime).yMMMMd.toString());
            var dayName = "";
            if (weatherDateTime.day == dateTimeNow.day) {
              dayName = "Bugün";
            } else if (weatherDateTime.day < dateTimeNow.day) {
              dayName = "Dün";
            } else {
              dayName = Jiffy(weatherDateTime).EEEE;
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
                        Icon(Icons.water_drop,size: 20,),
                        SizedBox(width: 10),
                        Text("%${AppUtils.xtodayLastHumidity(weatherModelGfs,pos).toString()}",style: TextStyle(color: Colors.grey),),
                        SizedBox(width: 10),
                        getTypeWeather(weatherModelGfs.ptypeSurface![pos],iconSize: 30)
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    child:Text("${AppUtils.getCelsiusText(_celsius)}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
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
    );
  }
  static Icon getTypeWeather(int ptypeSurface,{double iconSize = 40}){
    switch(ptypeSurface){
      case 0:
        return Icon(Icons.cloud,size: iconSize);
      case 1:
        return LineIcon.cloudWithRain(size: iconSize);
      case 3:
        return Icon(Icons.add,size: iconSize);
      case 5:
        return Icon(Icons.cloudy_snowing,size: iconSize);
      case 8:
        return Icon(Icons.ice_skating,size: iconSize);
      default:
        return Icon(Icons.cloud,size: iconSize);
    }
  }
}
