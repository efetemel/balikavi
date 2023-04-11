import 'dart:io';
import 'dart:typed_data';

import 'package:balikavi/models/SignInModel.dart';
import 'package:balikavi/models/SignUpModel.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/views/SignUpView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import '../models/FriendModel.dart';
import '../models/UserModel.dart';
import 'MainController.dart';



class UserController extends GetxController{

  static UserController instance = Get.find();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference storageRefImage = FirebaseStorage.instance.ref().child("images");


  late Rx<User?> user;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<FriendModel> friendList = [FriendModel()].obs;
  RxList<FriendModel> pendingList = [FriendModel()].obs;
  RxList<FriendModel> searchedUserList = [FriendModel()].obs;
  var logged = false.obs;
  RxList<dynamic> searchedFriends = [].obs;


  RxList<dynamic> doneSearchedFriends = [].obs;
  RxList<dynamic> messagesFriends = [].obs;

  RxList<dynamic> friendId = [].obs;
  RxList<dynamic> myPendingId = [].obs;
  RxList<dynamic> blocksId = [].obs;


  @override
  void onReady() {
    friendList.clear();
    pendingList.clear();
    searchedUserList.clear();
    user = Rx<User?>(auth.currentUser);
    user.bindStream(auth.userChanges());// notify changes
    ever(user,_initialScreen);
    super.onReady();
  }

  _initialScreen(User? user) async{
    if(user == null){
      logged.value = false;
      logged.refresh();
    }
    else{
      logged.value = true;
      logged.refresh();
      await online();
      getUserAndSet();
      getFriendsAndSet();

    }
  }

  void getUserAndSet(){
    firestore.collection("users").doc(auth.currentUser!.uid).snapshots().listen((event) {
      userModel.value = UserModel.fromJson({
        "email": event.get("email"),
        "userName": event.get("userName"),
        "profileImage": event.get("profileImage"),
        "description": event.get("description"),
        "lastSeen": event.get("lastSeen"),
        "lastOnline": event.get("lastOnline"),
        "online": event.get("online"),
        "readedInfo": event.get("readedInfo"),
        "positions":event.get("positions")
      });
      userModel.refresh();
    });
  }

  void getFriendsAndSet(){
    firestore.collection("friends").doc(auth.currentUser!.uid).snapshots().listen((event) {
      friendId.value = event.get("friends");
      myPendingId.value  = event.get("pending");
      blocksId.value  = event.get("blocks");
      friendList.value = [];
      pendingList.value = [];
      friendList.refresh();
      pendingList.refresh();
      friendId.forEach((element)async {
        var reqUser = await firestore.collection("users").doc(element).get();
        var x = FriendModel.fromJson(reqUser.data()!);
        x.userId = element;
        if(friendList.value.where((element) => element.userId == x.userId).isEmpty){
          friendList.value.add(x);
          friendList.refresh();
        }
      });
      myPendingId.forEach((element)async {
        var reqUser = await firestore.collection("users").doc(element).get();
        var x = FriendModel.fromJson(reqUser.data()!);
        x.userId = element;
        if(pendingList.value.where((element) => element.userId == x.userId).isEmpty){
          pendingList.value.add(x);
          pendingList.refresh();
        }
      });
      friendList.refresh();
      pendingList.refresh();
    });
  }


  Future seenMessage(String messageId,String receiverId) async{
    var response = await firestore.collection("users").doc(user.value!.uid).collection("messages").doc(messageId).get();
    response.reference.update({"seen":true});
    var response1 = await firestore.collection("users").doc(receiverId.trim()).collection("messages").doc(messageId).get();
    response1.reference.update({"seen":true});
  }

  Future forwardedMessage(String chatId,String messageId) async{
    var response = await firestore.collection("messages").doc(chatId).collection("messages").doc(messageId).get();
    response.reference.update({"forwarded":true});
  }

  Future changeLastSeen(bool _seen) async{
    await firestore.collection("users").doc(auth.currentUser!.uid).update({
      "lastSeen":_seen
    });
  }

  Future changeReadedInfo(bool _readedInfo) async{
    await firestore.collection("users").doc(auth.currentUser!.uid).update({
      "readedInfo":_readedInfo
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotForwardedMessage(String chatId){
    var response = firestore
        .collection("messages")
        .doc(chatId)
        .collection("messages")
        .orderBy("sendTime")
        .where("receiverId",isEqualTo: auth.currentUser!.uid)
        .where("forwarded",isEqualTo: false).snapshots();
    return response;
  }

  Future signIn(SignInModel signInModel)async{
    if(signInModel.email!.isNotEmpty && signInModel.email!.isEmail && signInModel.password!.isNotEmpty){
      try{
        var response = await auth.signInWithEmailAndPassword(email: signInModel.email!, password: signInModel.email!);
      }
      catch(err){
        if(err.toString().contains("firebase_auth/user-not-found")){
          AppUtils.showNotification("Giriş işlemi", "E-posta veya şifre hatalı");
        }
      }
    }
    else{
      AppUtils.showNotification("Giriş işlemi", "Bilgileri eksiksiz giriniz.");
    }
  }

  Future signUp(SignUpModel signUpModel) async{
    try{
      var existUserUsername = await firestore.collection("users").where("userName",isEqualTo: signUpModel.userName).get();
      if(existUserUsername.docs.isNotEmpty){
        AppUtils.showNotification("Kayıt işlemi", "Kullanıcı adı zaten kayıtlı");
        return;
      }
      var response = await auth.createUserWithEmailAndPassword(email: signUpModel.email!, password: signUpModel.password!);
      Timestamp stamp = Timestamp.fromDate(DateTime.now());
      var data = {
        "userName":signUpModel.userName!,
        "email":signUpModel.email!,
        "lastSeen":true,
        "profileImage":"default",
        "description":signUpModel.description,
        "online":false,
        "readedInfo":true,
        "lastOnline":stamp.toString(),
        "blocks":[],
        "pending":[],
        "friends":[],
        "positions":[]
      };
      var usr  = UserModel.fromJson(data);
       firestore.collection("users").doc(response.user!.uid).set(data).then((value)async{
         firestore.collection("friends").doc(response.user!.uid).set({
           "blocks":[],
           "pending":[],
           "friends":[],
         });
         Get.back();
         Get.back();
         logged.value = true;
         logged.refresh();
         userModel.value = usr;
         userModel.refresh();
         await online();
         getUserAndSet();
         getFriendsAndSet();
         AppUtils.showNotification("Kayıt başarılı", "Hoşgeldin sayın, ${signUpModel.userName}");
       });

    }catch(err){
    }
  }

  Future logout() async{
    userModel.value = UserModel();
    await auth.signOut();
  }

  Future searchFriends(TextEditingController query) async{
    if(query.text.isNotEmpty){
      doneSearchedFriends.clear();
      searchedUserList.value = [];
      searchedUserList.refresh();
      var responsesUserInfos = await firestore.collection("users").where("userName",isGreaterThanOrEqualTo: query.text).get();
      responsesUserInfos.docs.forEach((element) async {
        var responsesFriends = await firestore.collection("friends").doc(element.id).get();
        List userFriends = responsesFriends.get("friends");
        List userBlock = responsesFriends.get("blocks");
        List userPending = responsesFriends.get("pending");
        //ark değilsek && ben engellemediysem  && o benim ark değilse && o beni engellemediyse &&  id bana ait değilse
        if(!friendId.contains(element.id) &&
            !blocksId.contains(element.id) &&
            !userFriends.contains(auth.currentUser!.uid) &&
            !userBlock.contains(auth.currentUser!.uid) &&
            element.id != auth.currentUser!.uid){
          doneSearchedFriends.add(element.id);
          query.clear();
          searchedFriends.value = doneSearchedFriends;
          searchedFriends.refresh();
          var x = FriendModel.fromJson(element.data());
          x.userId = element.id;
          searchedUserList.value.add(x);
          searchedUserList.refresh();
          //Get.to(()=>AddFriendView(doneSearchedFriends));
        }
      });
    }
    else{
      AppUtils.showNotification("Arkadaş istekleri", "Kullanıcı adı giriniz.");
    }
  }

  Future addFriendAddPending(String userId) async{
    var oldUserInfos = await firestore.collection("friends").doc(userId).get();
    List userPending = oldUserInfos.get("pending");
    if(!userPending.contains(auth.currentUser!.uid)){
      userPending.add(auth.currentUser!.uid);
      oldUserInfos.reference.update({
        "pending":userPending
      });
      Get.back();
      Get.back();
      MainController.instance.scaffoldKey.value.currentState!.closeDrawer();
      AppUtils.showNotification("Arkadaş istekleri", "İstek gönderildi.");
    }
    else{
      AppUtils.showNotification("Arkadaş istekleri", "Zaten istek gönderdiniz.");
    }
  }

  Future acceptFriendRequest(String userId) async{
    var userFriend = await firestore.collection("friends").doc(userId).get();
    var myFriend = await firestore.collection("friends").doc(auth.currentUser!.uid).get();
    List userFriends = userFriend.get("friends");
    List userPending = userFriend.get("pending");
    List myUserFriends = myFriend.get("friends");
    List myUserPending = myFriend.get("pending");

    userFriends.add(auth.currentUser!.uid);
    userPending.remove(auth.currentUser!.uid);
    myUserFriends.add(userId);
    myUserPending.remove(userId);

    userFriend.reference.update({
      "friends":userFriends,
      "pending":userPending
    });

    myFriend.reference.update({
      "friends":myUserFriends,
      "pending":myUserPending
    });
    Get.back();
    AppUtils.showNotification("Arkadaş istekleri", "İsteği kabul ettin.");

  }

  Future declineFriendRequest(String userId) async{
    var myFriend = await firestore.collection("friends").doc(auth.currentUser!.uid).get();
    List myUserPending = myFriend.get("pending");
    myUserPending.remove(userId);
    myFriend.reference.update({
      "pending":myUserPending
    });
    Get.back();
    AppUtils.showNotification("Arkadaş istekleri", "İstek reddeildi.");
  }

  Future cancelFriendRequest(String userId) async{
    var userFriend = await firestore.collection("friends").doc(userId).get();
    List userPending = userFriend.get("pending");
    userPending.remove(auth.currentUser!.uid);
    userFriend.reference.update({
      "pending":userPending
    });
    Get.back();
    AppUtils.showNotification("Arkadaş istekleri", "İsteği geri çektin.");
  }

  Future offline() async{
    Timestamp stamp = Timestamp.fromDate(DateTime.now());
    var response = await firestore.collection("users").doc(auth.currentUser!.uid).get();
    response.reference.update({
      "online":false,
      "lastOnline":stamp
    });
  }

  Future online() async{
    var response = await firestore.collection("users").doc(auth.currentUser!.uid).get();
    response.reference.update({
      "online":true,
      "lastOnline":DateTime.now().toString()
    });
  }

  Future sendHelloMessage(String senderId,String receiverId) async{
    messagesFriends.add(receiverId);
    var date = DateTime.now();
    var helloMessage = "Selam!";
    var x = await firestore.collection("users").doc(user.value!.uid).collection("messages").add({
      "receiverId":receiverId,
      "senderId":senderId,
      "message": helloMessage,
      "messageType":"Text",
      "sendTime":date,
      "seen":false,
      "forwarded":false
    });
    var sendMessage2 = await firestore.collection("users").doc(receiverId).collection("messages").add({
      "receiverId":receiverId,
      "senderId":senderId,
      "message": helloMessage,
      "messageType":"Text",
      "sendTime":date,
      "seen":false,
      "enabled":true,
      "forwarded":false
    });
    //Get.to(()=>ChatView(receiverId, x.id));
  }

  Future sendImageMessage(String senderId,String receiverId,File image)async{
    messagesFriends.add(receiverId);
    var date = DateTime.now();
    var x = await firestore.collection("users").doc(user.value!.uid).collection("messages").add({
      "receiverId":receiverId,
      "senderId":senderId,
      "message": "loading",
      "messageType":"Image",
      "sendTime":date,
      "seen":false,
      "forwarded":false
    });
    var sendMessage2 = await firestore.collection("users").doc(receiverId).collection("messages").doc(x.id).set({
      "receiverId":receiverId,
      "senderId":senderId,
      "message": "loading",
      "sendTime":date,
      "messageType":"Image",
      "seen":false,
      "enabled":true,
      "forwarded":false
    });
    final uploadTask = storageRefImage.child("${x.id}.jpg").putFile(image);
    final url = await uploadTask.whenComplete(() => null).then((value) => value.ref.getDownloadURL());
    await x.update({"message":url});
    await firestore.collection("users").doc(receiverId).collection("messages").doc(x.id).update({"message":url});
  }

  Future sendMessage(String senderId,String receiverId,String message,String messageType) async{
   if(message.trim().isNotEmpty && messageType.trim().isNotEmpty){
     messagesFriends.add(receiverId);
     var date = DateTime.now();
     var x = await firestore.collection("users").doc(user.value!.uid).collection("messages").add({
       "receiverId":receiverId,
       "senderId":senderId,
       "message": message.trim(),
       "messageType":messageType,
       "sendTime":date,
       "seen":false,
       "forwarded":false
     });
     var sendMessage2 = await firestore.collection("users").doc(receiverId).collection("messages").doc(x.id).set({
       "receiverId":receiverId,
       "senderId":senderId,
       "message": message.trim(),
       "sendTime":date,
       "messageType":messageType,
       "seen":false,
       "enabled":true,
       "forwarded":false
     });
   }
  }

  Future deleteMyMessage(String messageId,String receiverId) async{
    Get.back();
    var response = await firestore.collection("users").doc(user.value!.uid).collection("messages").doc(messageId).get();
    var response1 = await firestore.collection("users").doc(receiverId).collection("messages").doc(messageId).get();
    var sendedData = {
      "message":"Bu mesaj silindi",
      "enabled":false,
      "messageType":"Text"
    };
    response.reference.update(sendedData);
    response1.reference.update(sendedData);
  }

  Future deleteMyImageMessage(String messageId,String receiverId)async{
    Get.back();
    var response = await firestore.collection("users").doc(user.value!.uid).collection("messages").doc(messageId).get();
    var response1 = await firestore.collection("users").doc(receiverId).collection("messages").doc(messageId).get();
    var sendedData = {
      "message":"Bu mesaj silindi",
      "enabled":false,
      "messageType":"Text"
    };
    var imgPath = "${response.id}.jpg";
    var img = storageRefImage.child(imgPath);
    await img.delete();
    response.reference.update(sendedData);
    response1.reference.update(sendedData);
  }

  Future checkPositions()async{
    var mainController = Get.find<MainController>();
    if(mainController.appSettings.value.positions != userModel.value.positions){
      await reloadPositions();
    }
  }

  Future reloadPositions()async{
    var y = [];
    MainController.instance.appSettings.value.positions!.forEach((element) {
      y.add({"latitude":element.latitude,"longitude":element.longitude});
    });
    firestore.collection("users").doc(user.value!.uid).update({
      "positions":y
    });

  }

  Future deleteFriend(String userId)async{
    var oldFriends = friendId;
    oldFriends.removeWhere((element) => element == userId);
    firestore.collection("friends").doc(user.value!.uid).update({
      "friends":oldFriends
    });
    var friendFriendsReq = await firestore.collection("friends").doc(userId).get();
    var friendFriendsList = friendFriendsReq.get("friends") as List;
    friendFriendsList.removeWhere((element) => element == user.value!.uid);
    firestore.collection("friends").doc(userId).update({
      "friends":friendFriendsList
    });
    Get.back();
    AppUtils.showNotification("Arkadaş işlemleri", "Arkadaş silindi.");
  }

  Future deleteFriendRequest(String userId)async{
    var oldFriends = myPendingId;
    oldFriends.removeWhere((element) => element == userId);
    firestore.collection("pending").doc(user.value!.uid).update({
      "pending":oldFriends
    });
    var friendFriendsReq = await firestore.collection("pending").doc(userId).get();
    var friendFriendsList = friendFriendsReq.get("pending") as List;
    friendFriendsList.removeWhere((element) => element == user.value!.uid);
    firestore.collection("pending").doc(userId).update({
      "pending":friendFriendsList
    });
    Get.back();
    AppUtils.showNotification("Arkadaş işlemleri", "Arkadaş isteği silindi.");
  }

  Widget showMessageUseType(dynamic message)  {
    if(message.get("message") == "loading"){
      return Container();
    }
    switch(message.get("messageType")){
      case "Text":
        return Text(message.get("message"));
      case "Image":
        if(message.get("receiverId") == user.value!.uid){
          return InkWell(
            onTap: (){
              Get.defaultDialog(
                title: "Medya kaydetme",
                middleText: "Medyayı kaydetmek istiyor musunuz?",
                confirm: ElevatedButton(onPressed: ()async{
                  Get.back();
                  var response = await MainController.instance.dio.get(message.get("message"), options: Options(responseType: ResponseType.bytes));
                  final result = await ImageGallerySaver.saveImage(
                      Uint8List.fromList(response.data),
                      quality: 100);
                  AppUtils.showNotification("Resim kaydetme", "Resim kaydedildi");
                }, child: Text("Kaydet")),
                cancel: ElevatedButton(onPressed: (){Get.back();}, child: Text("İptal")),
              );
            },
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: message.get("message"),
                  placeholder: (context, url) => Container(alignment: Alignment.center,child: CircularProgressIndicator(),),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 250,
                ),
                SizedBox(height: 5)
              ],
            ),
          );
        }
        return  Column(
          children: [
            CachedNetworkImage(
              imageUrl: message.get("message"),
              placeholder: (context, url) => Container(alignment: Alignment.center,child: CircularProgressIndicator(),),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
              width: 250,
            ),
            SizedBox(height: 5)
          ],
        );
      case "Emoji":
        return Text(message.get("message"));
      default:
        return Container();
    }
  }

  Widget seenMessageWiget(dynamic message){
    try{
      if(message.get("enabled") == false){
        return Container();
      }
      return Container();
    }catch(err){
      return message.get("seen") == true ? Icon(Icons.done_all,size: 16,) : Icon(Icons.done,size: 16);
    }

  }

  Widget showLastMessageType(dynamic message){
    switch(message.get("messageType")){
      case "Text":
        return Text("${message.get("senderId") == user.value!.uid ? "Siz:" : ""}${message.get("message")}");
      case "Image":
        return Row(
          children: [
            message.get("senderId") == user.value!.uid ? Text("Siz: ") : Container(),
            Icon(Icons.image)
          ],
        );
      default:
        return Container();
    }
  }

}