import 'package:balikavi/models/AppSettings.dart';
import 'package:balikavi/models/SignUpModel.dart';
import 'package:balikavi/models/UserModel.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/utils/Links.dart';
import 'package:balikavi/views/HomeView.dart';
import 'package:balikavi/views/SignInView.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../AuthService.dart';
import '../models/SignInModel.dart';
import 'MainController.dart';

class UserController extends GetxController{
  static UserController instance = Get.find();
  static MainController mainController = Get.find();
  var user = UserModel().obs;
  var logged = false.obs;
  final _authService = AuthService();

  Rx<User?> firebaseUser = Rx<User?>(null);


  UserController(){
    _authService.auth.authStateChanges().listen((event) {
      if(event != null){
        firebaseUser.value = event!;
        firebaseUser.refresh();
        _authService.getUserInfo();
        logged.value = true;
        logged.refresh();
      }else{
        logged.value = false;
        logged.refresh();
      }
    });
  }

  Future checkPositions()async{
    await _authService.checkPositions();
  }

  Future reloadPositions()async{
    await _authService.reloadPositions();
  }

  // Giriş yap
  Future signInWithEmailAndPassword(SignInModel signInModel) async {
    var response = await _authService.signInWithEmailAndPassword(signInModel);
    if(response != ""){
      Get.snackbar("Giriş işlemi", response,
          snackPosition: SnackPosition.TOP);
    }
    else{
      logged.value = true;
      logged.refresh();
      Get.snackbar("Giriş işlemi", "Hoşgeldiniz, Sayın ${user.value.userName}",
          snackPosition: SnackPosition.TOP);
    }
  }

  // Kayıt ol
  Future registerWithEmailAndPassword(SignUpModel signUpModel) async {
    var response = await _authService.registerWithEmailAndPassword(signUpModel);
    if(response != ""){
      Get.snackbar("Kayıt işlemi", response,
          snackPosition: SnackPosition.TOP);
    }
    else{
      logged.value = true;
      logged.refresh();
      Get.back();
      Get.back();
      Get.snackbar("Kayıt işlemi", "Hoşgeldiniz, Sayın ${user.value.userName}",
          snackPosition: SnackPosition.TOP);
    }
  }

  Future signOut()async{
    logged.value = true;
    logged.refresh();
    var response = await _authService.signOut();
  }



}