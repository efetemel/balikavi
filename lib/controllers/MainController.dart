import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/models/PositionsModel.dart';
import 'package:balikavi/views/HomeView.dart';
import 'package:balikavi/views/WelcomeView.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>().obs;

  var mainText = "Hava Durumu".obs;

  var loadData = false.obs;

  var placesData = <Placemark>[].obs;

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
    determinePosition().then((_){});
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
      for (var element in appSettings.value.positions!) {
        getAddressFromLatLong(element);
      }
    }else{
      var posModel =  PositionsModel.fromJson({
        "latitude":myPosition.value.latitude,
        "longitude":myPosition.value.longitude
      });
      appSettings.value = AppSettings(
          firstOpen: false,
          token: null,
          positions:[posModel]
      );
      appSettings.refresh();
      getAddressFromLatLong(posModel);
      await settingsBox.write("app_settings", appSettings.toJson());
    }
    await WeatherController.instance.getWeatherData();
  }

  Future setToken(String token)async{
    appSettings.value.token = token;
    await settingsBox.write("app_settings", appSettings.toJson());
  }

  Future clearToken()async{
    await settingsBox.write("token", null);
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
    var posModel = PositionsModel(longitude: myPosition.value.longitude,latitude: myPosition.value.latitude);
    if(appSettings.value.positions!.where((element) => element.latitude == posModel.latitude && element.longitude == posModel.longitude).isEmpty){
      appSettings.value.positions!.add(posModel);
      getAddressFromLatLong(posModel);
      setSettings();
      loadData.value = false;
      loadData.refresh();
      await WeatherController.instance.getWeatherData();
    }
  }

  Future setSettings()async{
    await settingsBox.write("app_settings", appSettings.toJson());
  }

  Future<void> getAddressFromLatLong(PositionsModel position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude!, position.longitude!);
    Placemark place = placemarks[0];
    placesData.value.add(place);
    placesData.refresh();
  }
}
