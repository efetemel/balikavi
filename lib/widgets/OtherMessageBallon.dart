import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../controllers/UserController.dart';

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
              UserController.instance.showMessageUseType(message),
              Text(Jiffy(toDate).Hm),
            ],
          ),
        )
      ],
    );
  }
}
