import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/views/LoadingView.dart';
import 'package:balikavi/views/SearchView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import '../widgets/WeatherCard.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var weatherController = WeatherController.instance;

    Widget initWeather() {
      if(MainController.instance.loading.value){
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Hava Durumu"),
              centerTitle: true,
              background: Container(
                color: Colors.transparent,
              ),
            ),
            leading: IconButton(
                onPressed: () {
                  if (MainController.instance.scaffoldKey.value
                      .currentState!.isDrawerOpen) {
                    MainController
                        .instance.scaffoldKey.value.currentState!
                        .closeDrawer();
                    //close drawer, if drawer is open
                  } else {
                    MainController
                        .instance.scaffoldKey.value.currentState!
                        .openDrawer();
                    //open drawer, if drawer is closed
                  }
                },
                icon: Icon(Icons.menu)),
            actions: [
              IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.my_location)),
              IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.add))
            ],
          ),
          body: Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppUtils.boxNightColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               CircularProgressIndicator()
              ],
            ),
          ),
        );
      }
      if (weatherController.weatherModelGfs.value.length > 0) {
        return NestedScrollView(
            headerSliverBuilder: (_, bool innerBoxIsScrolled) {
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
                  leading: IconButton(
                      onPressed: () {
                        if (MainController.instance.scaffoldKey.value
                            .currentState!.isDrawerOpen) {
                          MainController
                              .instance.scaffoldKey.value.currentState!
                              .closeDrawer();
                          //close drawer, if drawer is open
                        } else {
                          MainController
                              .instance.scaffoldKey.value.currentState!
                              .openDrawer();
                          //open drawer, if drawer is closed
                        }
                      },
                      icon: Icon(Icons.menu)),
                  actions: [
                    IconButton(
                        onPressed: () {
                          MainController.instance.determinePosition();
                          MainController
                              .instance.scaffoldKey.value.currentState!
                              .closeDrawer();
                        },
                        icon: Icon(Icons.my_location)),
                    IconButton(
                        onPressed: () {
                          Get.to(() => SearchView());
                        },
                        icon: Icon(Icons.add))
                  ],
                )
              ];
            },
            body: Obx(
              () => RefreshIndicator(
                onRefresh: () async {
                  await weatherController.refreshWeatherData();
                },
                child: ListView.builder(
                  itemCount: weatherController.weatherModelGfs.value.length,
                  itemBuilder: (_, int pos) {
                    return WeatherCard(pos);
                  },
                ),
              ),
            ));
      }
      else {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Hava Durumu"),
              centerTitle: true,
              background: Container(
                color: Colors.transparent,
              ),
            ),
            leading: IconButton(
                onPressed: () {
                  if (MainController.instance.scaffoldKey.value
                      .currentState!.isDrawerOpen) {
                    MainController
                        .instance.scaffoldKey.value.currentState!
                        .closeDrawer();
                    //close drawer, if drawer is open
                  } else {
                    MainController
                        .instance.scaffoldKey.value.currentState!
                        .openDrawer();
                    //open drawer, if drawer is closed
                  }
                },
                icon: Icon(Icons.menu)),
            actions: [
              IconButton(
                  onPressed: () {
                    MainController.instance.determinePosition();
                    MainController
                        .instance.scaffoldKey.value.currentState!
                        .closeDrawer();
                  },
                  icon: Icon(Icons.my_location)),
              IconButton(
                  onPressed: () {
                    Get.to(() => SearchView());
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          body: Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppUtils.boxNightColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Hava Durumu Bulunamadı.")
              ],
            ),
          ),
        );
      }
    }

    return Obx(()=>initWeather());
  }
}
