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
  var imgLoad = false.obs;
  var imgFile = File("").obs;
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
                 UserController.instance.deleteMyMessage(message.id,message.get("receiverId"));
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
               Obx(()=> messageType()),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(Jiffy(toDate).Hm),
                    SizedBox(width: 5),
                    seenWidget()
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
  Widget seenWidget(){
    try{
      if(message.get("enabled") == false){
        return Container();
      }
      return Container();
    }catch(err){
      return message.get("seen") == true ? Icon(Icons.done_all,size: 16,) : Icon(Icons.done,size: 16);
    }

  }

  Widget messageType()  {
    if(message.get("messageType") == "Text"){
      imgLoad.value = false;
      imgLoad.refresh();
      return Text(message.get("message"));
    }
    else if(message.get("messageType") == "Image" && imgLoad.value == false){
      if(message.get("message") == "Bu mesaj silindi"){
        return Text(message.get("message"));
      }
      loadImage();
      return Container();
    }
    else if(message.get("messageType") == "Image" && imgLoad.value){
      return Column(
        children: [
          Container(
            width: 200,
            child: Image.file(imgFile.value,fit: BoxFit.fitWidth),
          ),
          SizedBox(height: 10)
        ],
      );

    }
    else{
      imgLoad.value = false;
      imgLoad.refresh();
      return Container(height: 0,width: 0,);
    }

  }

  Future loadImage()async{
    try{
      if(message.get("enabled")){}
    }catch(err){
      final bytes = base64.decode(message.get("message"));
      var path = await getTemporaryDirectory();
      final tempFile = File('${path.path}/${message.id}.jpg');
      await tempFile.writeAsBytes(bytes);
      final file = File(tempFile.path);
      imgLoad.value = true;
      imgFile.value = file;
      imgFile.refresh();
      imgLoad.refresh();
    }

  }
}
