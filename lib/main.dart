import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/views/HomeView.dart';
import 'package:balikavi/views/SignInView.dart';
import 'package:balikavi/views/SignUpView.dart';
import 'package:balikavi/views/WelcomeView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import 'controllers/MainController.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MainController());
  Get.put(WeatherController());
  Get.put(UserController());
  await Jiffy.locale(AppUtils.appLanguageShort);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppUtils.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: HomeView(),
    );
  }
}
