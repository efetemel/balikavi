import 'package:balikavi/utils/AppUtils.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 30),
            Text(AppUtils.appName,style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
