import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/views/ProfileView.dart';
import 'package:balikavi/views/SignInView.dart';
import 'package:balikavi/views/WeatherView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:line_icons/line_icons.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(()=>initializePage()),
      ),
      bottomNavigationBar: Obx(()=> AnimatedBottomNavigationBar(
        icons: AppUtils.bottomIcons,
        activeIndex: MainController.instance.homeTabIndex.value,
        splashColor: Colors.grey,
        inactiveColor: Colors.white54,
        gapLocation: GapLocation.none,
        backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
        onTap: (index){MainController.instance.homeTabIndex.value = index;},
        //other params
      )),
    );
  }

  Widget initializePage(){
    switch(MainController.instance.homeTabIndex.value){
      case 0:
        return Column(children: [Text(MainController.instance.myPosition.value.latitude.toString())],);
      case 1:
        return WeatherView();
      case 2:
        return Column();
      case 3:
        return Column();
      case 4:
        return profilePage();
      default:
        return Container();
    }
  }

  StatelessWidget profilePage(){
    if(UserController.instance.user.value.userName != null){
      return ProfileView(); // LOGGED
    }
    return SignInView();
  }
}
//https://www.youtube.com/watch?v=B9hsWOCXb_o