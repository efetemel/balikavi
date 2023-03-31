import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/models/PositionsModel.dart';
import 'package:balikavi/models/SignInModel.dart';
import 'package:balikavi/models/SignUpModel.dart';
import 'package:balikavi/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;



  // Giriş işlemi
  Future<String> signInWithEmailAndPassword(SignInModel signInModel) async {
    try {
      var userController = Get.find<UserController>();
      UserCredential result = await auth.signInWithEmailAndPassword(email: signInModel.email!, password: signInModel.password!,);
      userController.firebaseUser.value = result.user;
      userController.firebaseUser.refresh();
      var userGet = await getUserInfo();
      var check = await checkPositions();
      return "";
    } catch (e) {
      return "Bir hata oluştu tekrar dene!";
    }
  }

  // Kayıt işlemi
  Future<String> registerWithEmailAndPassword(SignUpModel signUpModel) async {
    try{
      var response = await checkUserUserName(signUpModel.userName!);
      if(response == true){
        var userController = Get.find<UserController>();
        UserCredential result = await auth.createUserWithEmailAndPassword(email: signUpModel.email!, password: signUpModel.password!);
        userController.firebaseUser.value = result.user;
        userController.firebaseUser.refresh();
        UserController.instance.user.value = UserModel.fromJson(signUpModel.toJson());
        var registered = await firestore.collection("users").doc(userController.firebaseUser.value!.uid).set({
          ...UserController.instance.user.value.toJson(),

        });
        var check = await firstPositions();
        var userGet = await getUserInfo();
        return "";
      }
      else{
        // userName kayıtlı
        return "Kullanıcı Adı kayıtlı";
      }
    }catch(err){
      return err.toString();
    }
  }

  Future firstPositions()async{
    var mainController = Get.find<MainController>();
    for (var element in mainController.appSettings.value.positions!){
      firestore.collection("users").doc(UserController.instance.firebaseUser.value!.uid).update({
        "positions":[element.toJson()]
      });
    }
  }

  Future getUserInfo()async{
    var userController = Get.find<UserController>();
    firestore.collection("users").doc(userController.firebaseUser.value!.uid).snapshots().listen((event) {
      userController.user.value = UserModel.fromJson(event.data()! as Map<String,dynamic>);
      userController.user.refresh();
    });
  }

  Future checkPositions()async{
    var mainController = Get.find<MainController>();
    if(mainController.appSettings.value.positions != UserController.instance.user.value.positions){
      await reloadPositions();
    }
  }

  Future reloadPositions()async{
    var y = [];
    MainController.instance.appSettings.value.positions!.forEach((element) {
      y.add({"latitude":element.latitude,"longitude":element.longitude});
    });
    firestore.collection("users").doc(UserController.instance.firebaseUser.value!.uid).update({
      "positions":y
    });

  }


  Future<bool> checkUserUserName(String userName) async{
    try{
      var check = await firestore.collection("users").where("userName",isGreaterThan:userName).get();
      return check.docs.isNotEmpty ? false : true;
    }catch(err){
      return true;
    }
  }

  // Oturumu kapat
  Future<void> signOut() async {
    var userController = Get.find<UserController>();
    await auth.signOut();
    userController.user.value = UserModel();
    userController.user.refresh();
  }
}