import 'dart:convert';
import 'dart:io';

import 'package:balikavi/controllers/UserController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';

class MyMessageBallon extends StatelessWidget {
  int pos;
  var message;
  DateTime toDate;
  MyMessageBallon(this.pos, this.message, this.toDate);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: new Key(pos.toString()),
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onLongPress: (){
           try{
             if(message.get("enabled") == null){

             }
           }catch(err){
             Get.defaultDialog(
               title: "Mesaj işlemleri",
               middleText: "Mesajı silmek isediğine emin misin?",
               confirm: ElevatedButton(onPressed: (){
                 if(message.get("messageType") == "Image"){
                   UserController.instance.deleteMyImageMessage(message.id,message.get("receiverId"));
                 }
                 else{
                   UserController.instance.deleteMyMessage(message.id,message.get("receiverId"));
                 }
               }, child: Text("Evet")),
               cancel: ElevatedButton(onPressed: (){Get.back();}, child: Text("İptal")),
             );
           }
          },
          radius: 20,
          child: Container(
            decoration: const BoxDecoration(
                color: Color.fromRGBO(80, 80, 80, 1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
            ),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                UserController.instance.showMessageUseType(message),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(Jiffy(toDate).Hm),
                    SizedBox(width: 5),
                    UserController.instance.seenMessageWiget(message)
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
 


}
