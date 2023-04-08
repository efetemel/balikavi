import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/views/AddFriendView.dart';
import 'package:balikavi/views/MessageView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../models/MessageModel.dart';

class ProfileView extends StatelessWidget {
   ProfileView({Key? key}) : super(key: key);

  var x = List.generate(30, (index) => null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        title: Text("Profilim"),
      ),
      body: SafeArea(
        child:Container(
          width: double.infinity,
          alignment: Alignment.center,
          child:RefreshIndicator(
            onRefresh: ()async{
              //await UserController.instance.refreshProfileView();
            },
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 20),
                    CircleAvatar(child: Text(UserController.instance.userModel.value.userName!.substring(0,1).toUpperCase()),),
                    Text(UserController.instance.userModel.value.userName!),
                    SizedBox(width: 20),
                    Text(UserController.instance.userModel.value.description!),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  height: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppUtils.boxNightColor
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Arkadaşlarım",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                          IconButton(onPressed: (){
                            Get.to(()=>AddFriendView());
                          }, icon: Icon(Icons.add))
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Obx(()=>ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: UserController.instance.friendList.value!.length,
                          itemBuilder: (_,int pos){
                            return InkWell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    CircleAvatar(child:Text(UserController.instance.friendList.value[pos].userName!.substring(0,1).toUpperCase())),
                                    Text(UserController.instance.friendList.value[pos].userName!)
                                  ],
                                ),
                              ),
                              onTap: (){
                                Get.to(()=>MessageView(UserController.instance.friendList.value[pos].userId!));
                              },
                              onLongPress: (){
                                Get.defaultDialog(
                                    title: "Arkadaş silme işlemi",
                                    middleText: "${UserController.instance.friendList.value[pos].userName!}, silmek istiyor musun?",
                                    confirm: ElevatedButton(onPressed: (){UserController.instance.deleteFriend(UserController.instance.friendId[pos]);}, child: Text("Sil")),
                                    cancel: ElevatedButton(onPressed: (){Get.back();}, child: Text("İptal"))
                                );
                              },
                            );
                          },
                        )),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  height: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppUtils.boxNightColor
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Arkadaş istekleri",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                      SizedBox(height: 10),
                      Expanded(
                        child: Obx(()=>ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: UserController.instance.pendingList.value!.length,
                          itemBuilder: (_,int pos){
                            return InkWell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    CircleAvatar(child:Text(UserController.instance.pendingList.value[pos].userName!.substring(0,1).toUpperCase())),
                                    Text(UserController.instance.pendingList.value[pos].userName!)
                                  ],
                                ),
                              ),
                              onTap: (){
                                Get.defaultDialog(
                                    title: "Arkadaş isteği kabul etme",
                                    middleText: "${UserController.instance.pendingList.value[pos].userName!}, isteği onaylıyor musun?",
                                    confirm: ElevatedButton(onPressed: (){UserController.instance.acceptFriendRequest(UserController.instance.pendingList.value[pos].userId!);}, child: Text("Onayla")),
                                    cancel: ElevatedButton(onPressed: (){Get.back();}, child: Text("İptal"))
                                );
                              },
                              onLongPress: (){
                                Get.defaultDialog(
                                    title: "Arkadaş isteği silme",
                                    middleText: "${UserController.instance.pendingList.value[pos].userName!}, silmek istiyor musun?",
                                    confirm: ElevatedButton(onPressed: (){UserController.instance.deleteFriendRequest(UserController.instance.pendingList[pos].userId!);}, child: Text("Sil")),
                                    cancel: ElevatedButton(onPressed: (){Get.back();}, child: Text("İptal"))
                                );
                              },
                            );
                          },
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
