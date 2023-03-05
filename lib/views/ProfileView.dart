import 'package:balikavi/controllers/UserController.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
