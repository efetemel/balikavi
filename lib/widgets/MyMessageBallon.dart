import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

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
        Container(
          decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(message.get("message")),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Jiffy(toDate).Hm),
                  SizedBox(width: 5),
                  message.get("seen") == true ? Icon(Icons.done_all,size: 16,) : Icon(Icons.done,size: 16,)
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
