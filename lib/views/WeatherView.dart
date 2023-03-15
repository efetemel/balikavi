import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/WeatherCard.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var weatherController = WeatherController.instance;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          alignment: Alignment.center,
          decoration: AppUtils.bgDecoration,
          child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: false,
                    expandedHeight: 240,
                    scrolledUnderElevation: 0.0,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text("Hava Durumu"),
                      centerTitle: true,
                      background: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    leading: IconButton(onPressed: (){},icon: Icon(Icons.menu)),
                    actions: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.add))
                    ],
                  ),
                ];
              },
              key: _formKey,
              body: Obx(
                    () => RefreshIndicator(
                      onRefresh: () async {
                        await weatherController.getWeatherData();
                      },
                      child: ListView.builder(
                        itemCount: weatherController.weatherModelGfs.value.length,
                        itemBuilder: (_, int pos) {
                          return WeatherCard(pos);
                        },
                      ),
                    ),
              )),
        )
    );
  }
}
