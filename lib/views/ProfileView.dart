import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/views/AddFriendView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

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
              await UserController.instance.refreshProfileView();
            },
            child: Obx(()=>ListView(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey)
                    ),
                    child:Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(child: Text(UserController.instance.user.value.userName!.toUpperCase().substring(0,1)),),
                              SizedBox(width: 10),
                              Text(UserController.instance.user.value.userName!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))
                            ],
                          ),
                          Text(UserController.instance.user.value.description!)
                        ],
                      ),
                    )
                ),
                UserController.instance.user.value.requests!.length > 0 ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  height: 150,
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
                          Text("Gelen istekler",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: UserController.instance.requestFriendList.value.length,
                          itemBuilder: (_,int pos){
                            return InkWell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    CircleAvatar(child:Text(UserController.instance.requestFriendList.value[pos].userName!.substring(0,1).toUpperCase())),
                                    Text(UserController.instance.requestFriendList.value[pos].userName!)
                                  ],
                                ),
                              ),
                              onTap: (){
                                Get.defaultDialog(
                                  title: "Arkadaş ekleme işlemi",
                                  middleText: "${UserController.instance.requestFriendList.value[pos].userName}, isteğini onaylıyor musunuz?",
                                  confirm: ElevatedButton(onPressed: (){
                                    UserController.instance.acceptFriendRequest(UserController.instance.requestFriendList.value[pos].userId!);
                                  }, child: Text("Onayla")),
                                  cancel: ElevatedButton(onPressed: (){
                                    UserController.instance.declineFriendRequest(UserController.instance.requestFriendList.value[pos].userId!);
                                  }, child: Text("Sil")),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ) : Container(),
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
                          itemCount: UserController.instance.friendUserList!.length,
                          itemBuilder: (_,int pos){
                            return InkWell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    CircleAvatar(child:Text(UserController.instance.friendUserList.value[pos].userName!.substring(0,1).toUpperCase())),
                                    Text(UserController.instance.friendUserList.value[pos].userName!)
                                  ],
                                ),
                              ),
                              onTap: (){

                              },
                              onLongPress: (){
                                Get.defaultDialog(
                                    title: "Arkadaş silme işlemi",
                                    middleText: "${UserController.instance.friendUserList.value[pos].userName!}, silmek istiyor musun?",
                                    confirm: ElevatedButton(onPressed: (){UserController.instance.deleteFriend(UserController.instance.friendUserList.value[pos].userId!);}, child: Text("Sil")),
                                    cancel: ElevatedButton(onPressed: (){Get.back();}, child: Text("İptal"))
                                );
                              },
                            );
                          },
                        )),
                      )
                    ],
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
