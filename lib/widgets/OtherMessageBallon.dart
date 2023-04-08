import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';

class OtherMessageBallon extends StatelessWidget {
  var message;
  DateTime toDate;
  var imgLoad = false.obs;
  var imgFile = File("").obs;
  OtherMessageBallon(this.message, this.toDate);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(100, 100, 100, 0.3),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(()=>messageType()),
              Text(Jiffy(toDate).Hm),
            ],
          ),
        )
      ],
    );
  }

  Widget messageType()  {
    if(message.get("messageType") == "Text"){
      imgLoad.value = false;
      imgLoad.refresh();
      return Text(message.get("message"));
    }
    else if(message.get("messageType") == "Image" && imgLoad.value == false){
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
