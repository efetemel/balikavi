import 'package:balikavi/controllers/UserController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jiffy/jiffy.dart';

import 'MessageView.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Mesajlar"),
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: UserController.instance.firestore.collection("users").doc(UserController.instance.user.value!.uid).collection("messages").orderBy("sendTime").snapshots(),
          builder: (_,AsyncSnapshot<QuerySnapshot> snap){
            if(snap.hasData){
              var userList = [];
             snap.data!.docs.toList().reversed.forEach((element) {
               if(element.get("receiverId") == UserController.instance.user.value!.uid){
                 if(userList.contains(element.get("senderId")) == false){
                   userList.add(element.get("senderId"));
                 }
               }
               else{
                 if(userList.contains(element.get("receiverId")) == false){
                   userList.add(element.get("receiverId"));
                 }
               }
             });
             return ListView.builder(
               itemCount: userList.length,
               itemBuilder: (_,int pos){
                 return FutureBuilder(
                   future: UserController.instance.firestore.collection("users").doc(userList[pos]).get(),
                   builder: (_,AsyncSnapshot snap1){
                     var msg = snap.data!.docs.lastWhere((element) => (element.get("senderId") == UserController.instance.user.value!.uid && element.get("receiverId") == userList[pos]) || (element.get("receiverId") == UserController.instance.user.value!.uid && element.get("senderId") == userList[pos]));
                     var msgTimeStamp = msg.get("sendTime") as Timestamp;
                     if(snap1.hasData){
                       return ListTile(
                         title: Text(snap1.data["userName"]),
                         leading: CircleAvatar(child: Text(snap1.data["userName"].toString().substring(0,1).toUpperCase())),
                         subtitle:UserController.instance.showLastMessageType(msg),
                         trailing: Text(Jiffy(msgTimeStamp.toDate()).Hm),
                         onTap: (){
                           Get.to(()=>MessageView(userList[pos]));
                         },
                       );
                     }
                     return Container();
                   },
                 );
               },
             );
            }
            else{
              return Container(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
  
 
}
