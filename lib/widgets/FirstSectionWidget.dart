import 'package:flutter/material.dart';

class FirstSectionWidget extends StatelessWidget {
  const FirstSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Text("Hava Durumu",style: TextStyle(fontSize: 40),),
    );
  }
}
