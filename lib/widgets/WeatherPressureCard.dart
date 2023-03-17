import 'package:balikavi/models/WeatherModelGfs.dart';
import 'package:flutter/material.dart';

import '../utils/AppUtils.dart';

class WeatherPressureCard extends StatelessWidget {
  WeatherModelGfs weatherModelGfs;

  WeatherPressureCard(this.weatherModelGfs, {super.key});

  @override
  Widget build(BuildContext context) {
    var pressure = AppUtils.todayLastPressure(weatherModelGfs);
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppUtils.boxNightColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hava Basıncı",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,fontSize: 17),),
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pressure > 50 ? Icon(Icons.arrow_upward_outlined) : Icon(Icons.arrow_downward)
              ],
            ),
            trailing: Text("%${pressure.toString()}"),
          ),
        ],
      ),
    );
  }
}
