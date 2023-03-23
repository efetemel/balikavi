import 'package:balikavi/controllers/UserController.dart';
import 'package:flutter/material.dart';

class UserDrawHeaderWidget extends StatelessWidget {
  const UserDrawHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName:Text(UserController.instance.user.value.userName!),
      accountEmail: Text(UserController.instance.user.value.email!),
      currentAccountPicture: CircleAvatar(backgroundColor: Colors.grey,child: Text(UserController.instance.user.value.userName!.substring(0,1).toUpperCase(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),),
      decoration: BoxDecoration(
          color: Colors.transparent
      ),
    );
  }
}
