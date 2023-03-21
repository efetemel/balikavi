import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/views/FishView.dart';
import 'package:balikavi/views/LoadingView.dart';
import 'package:balikavi/views/LocationView.dart';
import 'package:balikavi/views/ProfileView.dart';
import 'package:balikavi/views/SearchView.dart';
import 'package:balikavi/views/SettingsView.dart';
import 'package:balikavi/views/SignInView.dart';
import 'package:balikavi/views/WeatherView.dart';
import 'package:balikavi/widgets/UserDrawHeaderWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class HomeView extends StatelessWidget {
   HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: MainController.instance.scaffoldKey.value,
      body: Obx(()=> beforeInit()),
      drawer:Drawer(
        child: ListView(
          children: [
            UserDrawHeaderWidget(),
            ListTile(
              leading: Icon(Icons.sunny),
              title: Text("Hava Durumu"),
              onTap: (){
                if(MainController.instance.homeTabIndex.value != 0){
                  MainController.instance.homeTabIndex.value = 0;
                  MainController.instance.scaffoldKey.value.currentState!.closeDrawer();
                }
              },
            ),
            ListTile(
              leading: LineIcon.fish(),
              title: Text("Balık Durumu"),
              onTap: (){
                if(MainController.instance.homeTabIndex.value != 1){
                  MainController.instance.homeTabIndex.value = 1;
                  MainController.instance.scaffoldKey.value.currentState!.closeDrawer();
                }
              },
            ),
            ListTile(
              leading: LineIcon.mapMarker(),
              title: Text("Konumlarım"),
              onTap: (){
                if(MainController.instance.homeTabIndex.value != 2){
                  MainController.instance.homeTabIndex.value = 2;
                  MainController.instance.scaffoldKey.value.currentState!.closeDrawer();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Ayarlar"),
              onTap: (){
                if(MainController.instance.homeTabIndex.value != 3){
                  MainController.instance.homeTabIndex.value = 3;
                  MainController.instance.scaffoldKey.value.currentState!.closeDrawer();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Hesabım"),
              onTap: (){
                if(MainController.instance.homeTabIndex.value != 4){
                  MainController.instance.homeTabIndex.value = 4;
                  MainController.instance.scaffoldKey.value.currentState!.closeDrawer();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text("Mesajlar"),
              onTap: (){
                if(MainController.instance.homeTabIndex.value != 5){
                  MainController.instance.homeTabIndex.value = 5;
                  MainController.instance.scaffoldKey.value.currentState!.closeDrawer();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Çıkış yap"),
              onTap: (){
                //exit
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget beforeInit(){
    if(MainController.instance.loadData.value){
      return Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: AppUtils.bgDecoration,
        child:initializePage(),
      );
    }
    else{
      return LoadingView();
    }
  }

  Widget initializePage(){
    switch(MainController.instance.homeTabIndex.value){
      case 0:
        return WeatherView();
      case 1:
        return FishView();
      case 2:
        return LocationView();
      case 3:
        return SettingsView();
      case 4:
        return ProfileView();
      case 5:
        return LocationView();
      default:
        return Container();
    }
  }
}