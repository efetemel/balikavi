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
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
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
      drawer:Obx(()=>Drawer(
        child: ListView(
          children: [
            UserController.instance.logged.value ?  UserDrawHeaderWidget() : SizedBox(height: 10,),
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
                Get.to(()=>LocationView());
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Ayarlar"),
              onTap: (){
                Get.to(()=>SettingsView());
              },
            ),
            UserController.instance.logged.value ? ListTile(
              leading: Icon(Icons.person),
              title: Text("Hesabım"),
              onTap: (){
                Get.to(()=>ProfileView());
              },
            ) : Container(),
            UserController.instance.logged.value ? ListTile(
              leading: Icon(Icons.message),
              title: Text("Mesajlar"),
              onTap: (){
                if(MainController.instance.homeTabIndex.value != 5){
                  MainController.instance.homeTabIndex.value = 5;
                  MainController.instance.scaffoldKey.value.currentState!.closeDrawer();
                }
              },
            ) : Container(),
            UserController.instance.logged.value ? ListTile(
              leading: Icon(Icons.logout),
              title: Text("Çıkış yap"),
              onTap: ()async{
                await UserController.instance.signOut();
              },
            ) : Container(),
            UserController.instance.logged.value == false ? ListTile(
              leading: Icon(Icons.login),
              title: Text("Giriş yap"),
              onTap: (){
                Get.to(()=>SignInView());
              },
            ) : Container()
          ],
        ),
      )),
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
      default:
        return Container();
    }
  }
}