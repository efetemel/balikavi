import 'package:balikavi/models/AppSettings.dart';
import 'package:balikavi/models/SignUpModel.dart';
import 'package:balikavi/models/UserModel.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/utils/Links.dart';
import 'package:balikavi/views/HomeView.dart';
import 'package:balikavi/views/SignInView.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/SignInModel.dart';
import 'MainController.dart';

class UserController extends GetxController{
  static UserController instance = Get.find();
  static MainController mainController = Get.find();
  var user = UserModel().obs;
  var logged = false.obs;

  Future signUp(SignUpModel signUpModel) async{
    try{
      var response = await mainController.dio.post(Links.myApiSignUp,data: signUpModel.toJson());
      AppUtils.showNotification("Kayıt Olma işlemi","Tebrikler kayıt oluşturuldu");
      Get.back();
    }catch(err){
      if(err is DioError){
        AppUtils.showNotification("Kayıt Olma işlemi", err.response.toString());
      }
    }
  }

  Future signIn(SignInModel signInModel) async{
    try{
      var response = await mainController.dio.post(Links.myApiSignIn,data: signInModel.toJson());
      MainController.instance.setToken(response.data["token"]);
      MainController.instance.dio.options = BaseOptions(headers: {"Authorization":response.data["token"]});
      await getSettings();
    }catch(err){
      print(err);
      if(err is DioError){
        AppUtils.showNotification("Giriş yapma işlemi", err.response.toString());
      }
    }
  }

  Future getSettings() async{
    try{
      var response = await mainController.dio.get(Links.myApiGetSettings);
      user.value =  UserModel.fromJson(response.data);
      user.refresh();
      logged.value = true;
      logged.refresh();
      MainController.instance.homeTabIndex.value = 0;
      MainController.instance.homeTabIndex.refresh();
      Get.back();
      MainController.instance.scaffoldKey.value.currentState!.closeDrawer();
      AppUtils.showNotification("Hoşgeldiniz!","Sayın ${user.value.userName}");
    }catch(err){
      if(err is DioError){
        MainController.instance.clearToken();
        logged.value = false;
        logged.refresh();
      }
    }
  }

  Future logout()async{
    user.value = UserModel();
    user.refresh();
    logged.value = false;
    logged.refresh();
    MainController.instance.homeTabIndex.value = 0;
    MainController.instance.homeTabIndex.refresh();
  }


}