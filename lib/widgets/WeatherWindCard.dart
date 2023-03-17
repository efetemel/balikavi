import 'package:balikavi/models/WeatherModelGfs.dart';
import 'package:flutter/material.dart';
import '../utils/AppUtils.dart';

class WeatherWindCard extends StatelessWidget {
  WeatherModelGfs weatherModelGfs;

  WeatherWindCard(this.weatherModelGfs,{super.key});

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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rüzgar Yönleri",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.grey),),
          SizedBox(height: 5),
          ListTile(
            title: Text("Batıdan Doğuya"),
            trailing: Container(
              child: AppUtils.todayLastWindU(weatherModelGfs) > 0 ? Icon(Icons.arrow_forward_ios) : Icon(Icons.arrow_back_ios),
            ),
          ),
          SizedBox(height: 5),
          Container(width: double.infinity,height: 0.5,color:Colors.grey),
          ListTile(
            title: Text("Kuzeyden Güneye"),
            trailing: Container(
              child: AppUtils.todayLastWindV(weatherModelGfs) > 0 ? Icon(Icons.arrow_upward) : Icon(Icons.arrow_downward),
            ),
          ),
        ],
      ),
    );
  }
}
