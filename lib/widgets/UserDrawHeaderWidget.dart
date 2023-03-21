import 'package:flutter/material.dart';

class UserDrawHeaderWidget extends StatelessWidget {
  const UserDrawHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName:Text("Efe Temel"),
      accountEmail: Text("ersozyazilim@gmail.com"),
      currentAccountPicture: CircleAvatar(backgroundColor: Colors.red,),
      decoration: BoxDecoration(
          color: Colors.transparent
      ),
    );
  }
}
