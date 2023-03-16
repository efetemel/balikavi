import 'package:balikavi/models/WeatherModelGfs.dart';
import 'package:balikavi/widgets/WeatherCard.dart';
import 'package:balikavi/widgets/WeatherDetailCart.dart';
import 'package:flutter/material.dart';

class WeatherDetailsView extends StatelessWidget {
  int pos;
  WeatherModelGfs weatherModelGfs;

  WeatherDetailsView(this.pos, this.weatherModelGfs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hava Detayı"),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WeatherCard(pos,isClickeble: false),
            Expanded(child:  WeatherDetailCard(weatherModelGfs)),
          ],
        ),
      ),
    );
  }
}
