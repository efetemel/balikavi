import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/views/HomeView.dart';
import 'package:balikavi/views/WelcomeView.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/AppSettings.dart';
import '../utils/AppUtils.dart';

class MainController extends GetxController {
  static MainController instance = Get.find();
  Dio dio = Dio();
  var settingsBox = GetStorage("Settings");
  var appSettings = AppSettings().obs;
  var homeTabIndex = 0.obs;
  var locationPerm = false.obs;

  var myPosition = Position(
      accuracy: 0,
      altitude: 0,
      heading: 0,
      latitude: 41.015137,
      longitude: 28.979530,
      speed: 0,
      speedAccuracy: 0,
      timestamp: DateTime.now(),
      floor: 0,
      isMocked: true
  ).obs;


  MainController() {
    readSettings();
    determinePosition().then((_){
    });
  }

  Future setToken(String token)async{
    appSettings.value.token = token;
    await settingsBox.write("app_settings", appSettings.toJson());
  }

  Future clearToken()async{
    await settingsBox.write("token", null);
  }

  Future readSettings() async{
    await GetStorage.init();
    var response = await settingsBox.read("app_settings");
    if(response != null){
      appSettings.value = AppSettings.fromJson(response);
      if(appSettings.value.token != null){
        dio.options = BaseOptions(headers: {"Authorization":appSettings.value.token});
        await UserController.instance.getSettings();
      }
    }else{
      appSettings.value = AppSettings(firstOpen: false,token: null);
      await settingsBox.write("app_settings", appSettings.toJson());
    }
  }

  Future determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      locationPerm.value = false;
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      AppUtils.showNotification("Sistem bilgisi", "Konum izni vermeniz gerekmektedir.");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        AppUtils.showNotification("Sistem bilgisi", "Konum izni vermeniz gerekmektedir.");
        locationPerm.value = false;
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      permission = await Geolocator.requestPermission();

      AppUtils.showNotification("Sistem bilgisi", "Konum izni vermeniz gerekmektedir.");
      locationPerm.value = false;
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    locationPerm.value = true;
    myPosition.value =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
