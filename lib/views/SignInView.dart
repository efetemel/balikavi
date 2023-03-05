import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/models/SignInModel.dart';
import 'package:balikavi/views/SignUpView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/AppUtils.dart';

class SignInView extends StatelessWidget {
   SignInView({Key? key}) : super(key: key);

  final String middleText = "Ne bekliyorsun haydi!";

  var emailOrUserNameController = TextEditingController();
  var passwordController = TextEditingController();

  void handleSignIn(){
    if(emailOrUserNameController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty){
      UserController.instance.signIn(SignInModel(emailOrUserName: emailOrUserNameController.text.trim(),password: passwordController.text.trim()));
    }
    else{
      AppUtils.showNotification("Giriş yapma işlemi", "Gerekli alanları doldurunuz!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppUtils.appName,style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold
                )),
                Text(middleText,style: TextStyle(
                  fontSize: 30,
                )),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "E-posta veya Kullanıcı Adı",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: emailOrUserNameController,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: "Şifre",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: true,
                        controller: passwordController,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(onPressed: (){handleSignIn();},style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white)), child: Text("Giriş yap")),
                      TextButton(onPressed: (){Get.to(()=>SignUpView());}, child: Text("Hesabın yok mu?")),
                      TextButton(onPressed: (){}, child: Text("Şifremi unuttum"))

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
