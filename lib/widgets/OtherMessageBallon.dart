import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class OtherMessageBallon extends StatelessWidget {
  var message;
  DateTime toDate;

  OtherMessageBallon(this.message, this.toDate);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(68, 68, 68, 1),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.get("message")),
              Text(Jiffy(toDate).Hm),
            ],
          ),
        )
      ],
    );
  }
}
