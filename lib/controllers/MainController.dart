import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/models/AppThemeModel.dart';
import 'package:balikavi/views/HomeView.dart';
import 'package:balikavi/views/WelcomeView.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/AppSettings.dart';
import '../utils/AppUtils.dart';

class MainController extends GetxController {
  static MainController instance = Get.find();
  var dio = Dio();
  var settingsBox = GetStorage("Settings");
  var appSettings = AppSettings().obs;
  var homeTabIndex = 0.obs;
  var locationPerm = false.obs;
  var placeData = Placemark().obs;
  var appTheme = AppUtils.dayTheme.obs;

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
    appTheme.value = AppUtils.getTheme();
    readSettings();
    getAddressFromLatLong(myPosition.value);
    determinePosition().then((_){});
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

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationPerm.value = false;
      AppUtils.showNotification("Sistem bilgisi", "Konum servisleri devre dışı.");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppUtils.showNotification("Sistem bilgisi", "Konum izni vermeniz gerekmektedir.");
        locationPerm.value = false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      AppUtils.showNotification("Sistem bilgisi", "Konum izinleri kalıcı olarak reddedildi.");
      locationPerm.value = false;
    }

    locationPerm.value = true;
    myPosition.value =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    getAddressFromLatLong(myPosition.value);
    await WeatherController.instance.getWeatherData();

  }

  Future<void> getAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    placeData.value = place!;
  }
}
