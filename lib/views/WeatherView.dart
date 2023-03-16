import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/utils/AppUtils.dart';
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

    return NestedScrollView(
        headerSliverBuilder: (_,bool innerBoxIsScrolled){
          return [
            SliverAppBar(
              pinned:false,
              expandedHeight:240,
              scrolledUnderElevation: 0.0,
              backgroundColor: Colors.transparent ,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(MainController.instance.mainText.value),
                centerTitle: true,
                background: Container(
                  color: Colors.transparent,
                ),
              ),
              leading: IconButton(onPressed: (){
                if(MainController.instance.scaffoldKey.value.currentState!.isDrawerOpen){
                  MainController.instance.scaffoldKey.value.currentState!.closeDrawer();
                  //close drawer, if drawer is open
                }else{
                  MainController.instance.scaffoldKey.value.currentState!.openDrawer();
                  //open drawer, if drawer is closed
                }
              },icon: Icon(Icons.menu)),
              actions: [
                IconButton(onPressed: (){
                  Get.to(()=>SearchView());
                }, icon: Icon(Icons.add))
              ],
            )
          ];
        },
        body:Obx(
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
        )
    );
  }
}
