import 'package:balikavi/models/WeatherModelGfs.dart';
import 'package:balikavi/widgets/WeatherCard.dart';
import 'package:balikavi/widgets/WeatherDetailCart.dart';
import 'package:balikavi/widgets/WeatherPressureCard.dart';
import 'package:balikavi/widgets/WeatherSunSetRiseCard.dart';
import 'package:balikavi/widgets/WeatherWindCard.dart';
import 'package:flutter/material.dart';

import '../models/SunSetAndRiseModel.dart';

class WeatherDetailsView extends StatelessWidget {
  int pos;
  WeatherModelGfs weatherModelGfs;
  SunSetAndRiseModel sunSetAndRiseModel;

  WeatherDetailsView(this.pos, this.weatherModelGfs,this.sunSetAndRiseModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hava Detayı"),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
      ),
      body: ListView(
        children: [
          WeatherCard(pos,isClickeble: false),
          WeatherDetailCard(weatherModelGfs),
          WeatherWindCard(weatherModelGfs),
          WeatherSunSetRiseCard(weatherModelGfs, sunSetAndRiseModel),
          WeatherPressureCard(weatherModelGfs)
        ],
      ),
    );
  }
}
