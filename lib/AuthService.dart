import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/models/FriendModel.dart';
import 'package:balikavi/models/PositionsModel.dart';
import 'package:balikavi/models/SignInModel.dart';
import 'package:balikavi/models/SignUpModel.dart';
import 'package:balikavi/models/UserModel.dart';
import 'package:balikavi/utils/AppUtils.dart';
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
        UserController.instance.user.value = UserModel(
          positions:[],
          description: signUpModel.description,
          birthDate: signUpModel.birthDate,
          blocks: [],
          friends: [],
          requests: [],
          email: signUpModel.email,
          profilePhoto: signUpModel.profilePhoto,
          userName: signUpModel.userName
        );
        UserController.instance.user.refresh();
        var registered =  await firestore.collection("users").doc(userController.firebaseUser.value!.uid).set(UserController.instance.user.value.toJson());
        var check = await firstPositions();
        var userGet = await getUserInfo();
        return "";
      }
      else{
        print(response);
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
      if(event.data() != null){
        userController.user.value = UserModel.fromJson(event.data()! as Map<String,dynamic>);
        userController.user.refresh();
        getFriendList();
        getFriendRequestList();
      }

    });
  }

  Future getFriendRequestList()async{
    var userController = Get.find<UserController>();
    UserController.instance.requestFriendList.clear();
    userController.user.value.requests!.forEach((element) async{
      var x = await firestore.collection("users").doc(element).get();
      var y = FriendModel.fromJson(x.data()!);
      y.userId = element;
      UserController.instance.requestFriendList.value.add(y);
      UserController.instance.requestFriendList.refresh();
    });
    UserController.instance.requestFriendList.refresh();
  }

  Future getFriendList()async{
    var userController = Get.find<UserController>();
    UserController.instance.friendUserList.clear();
    userController.user.value.friends!.forEach((element) async{
      var x = await firestore.collection("users").doc(element).get();
      var y = FriendModel.fromJson(x.data()!);
      y.userId = element;
      UserController.instance.friendUserList.value.add(y);
      UserController.instance.friendUserList.refresh();
    });
    UserController.instance.friendUserList.refresh();
  }

  Future acceptFriendRequest(String userId)async{
    try{
      var x = await firestore.collection("users").doc(userId).get();
      UserController.instance.friendUserList.value.add(FriendModel.fromJson(x.data()!));
      UserController.instance.friendUserList.refresh();
      var xList = x.data()!["friends"] as List;
      xList.add(UserController.instance.firebaseUser.value!.uid);
      await firestore.collection("users").doc(userId).update({"friends":xList});
      UserController.instance.requestFriendList.value.removeWhere((element) => element.userId == userId);
      UserController.instance.user.value.requests!.removeWhere((element) => element == userId);
      var y = UserController.instance.user.value.friends;
      y!.add(userId);
      await firestore.collection("users").doc(UserController.instance.firebaseUser.value!.uid).update({
        "friends":y,
        "requests":UserController.instance.user.value.requests
      });
      Get.back();
      AppUtils.showNotification("Arkadaş ekleme", "Arkadaş ekledin!");
    }catch(err){
      AppUtils.showNotification("Arkadaş ekleme", "Bir hata oluştu!");
    }
  }

  Future declineFriendRequest(String userId) async{
    var friendsRequest = UserController.instance.requestFriendList.value;
    friendsRequest.removeWhere((element) => element.userId == userId);
    await firestore.collection("users").doc(UserController.instance.firebaseUser.value!.uid!).update({
      "requests":friendsRequest
    });
    Get.back();
    AppUtils.showNotification("İstek silme", "İstek silindi");
  }

  Future deleteFriend(String userId)async{
    try{
      Get.back();
      //kendimden silme
      var friends = UserController.instance.user.value.friends!;
      friends.removeWhere((element) => element == userId);
      await firestore.collection("users").doc(UserController.instance.firebaseUser.value!.uid).update({
        "friends":friends
      });
      var friendFriends = await firestore.collection("users").doc(userId).get();
      var data = friendFriends.data()!["friends"] as List;
      data.removeWhere((element) => element == UserController.instance.firebaseUser.value!.uid);
      await firestore.collection("users").doc(userId).update({
        "friends":data
      });
      AppUtils.showNotification("Arkadaş silme", "Arkadaş silindi.");
    }catch(err){
      AppUtils.showNotification("Arkadaş silme", "Bir hata oluştu!");
    }
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

  Future<List<FriendModel>> searchUser(String userName)async{
    var searchedUser = await firestore.collection("users").where("userName",isGreaterThanOrEqualTo: userName).get();
    var userList = <FriendModel>[];
    searchedUser.docs.forEach((element) {
      if(element.data()["userName"] != UserController.instance.user.value.userName){
        userList.add(
          FriendModel(
            userName: element.data()["userName"],
            profilePhoto: element.data()["profilePhoto"],
            userId: element.id,
            description: element.data()["description"]
          )
        );
      }
    });
    return userList;
  }

  Future sendFriendRequest(String userId)async{
    var requestedUser = await firestore.collection("users").doc(userId).get();
    var friends = requestedUser.data()!["requests"] as List;

    if(friends.contains(UserController.instance.firebaseUser.value!.uid) == false){
      await firestore.collection("users").doc(userId).update({
        "requests":[...UserController.instance.user.value.requests!,UserController.instance.firebaseUser.value!.uid]
      });
      AppUtils.showNotification("Arkadaş ekleme", "İstek gönderildi");
    }
    else{
      AppUtils.showNotification("Arkadaş ekleme", "Zaten istek göndermişsin!");
    }

  }


  Future<bool> checkUserUserName(String userName) async{
    try{
      var check = await firestore.collection("users").where("userName",isEqualTo:userName).get();
      print(userName);
      print(check.docs.first.data());
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