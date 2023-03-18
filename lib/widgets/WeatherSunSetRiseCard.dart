import 'package:balikavi/models/SunSetAndRiseModel.dart';
import 'package:balikavi/models/WeatherModelGfs.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:line_icons/line_icon.dart';

import '../utils/AppUtils.dart';

class WeatherSunSetRiseCard extends StatelessWidget {
  WeatherModelGfs weatherModelGfs;
  SunSetAndRiseModel sunSetAndRiseModel;

  WeatherSunSetRiseCard(this.weatherModelGfs, this.sunSetAndRiseModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppUtils.boxNightColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Güneş",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.grey),),
          SizedBox(height: 5),
          ListTile(
            leading: Icon(Icons.sunny,size: 30,),
            title: Text("Gün Doğumu"),
            trailing: Text(Jiffy(DateTime.parse(sunSetAndRiseModel.sunrise!)).Hm),
          ),
          SizedBox(height: 5),
          Container(width: double.infinity,height: 0.5,color:Colors.grey),
          SizedBox(height: 5),
          ListTile(
            leading: LineIcon.moon(),
            title: Text("Gün Batımı"),
            trailing: Text(Jiffy(DateTime.parse(sunSetAndRiseModel.sunset!)).Hm),
          ),
        ],
      ),
    );
  }
}
