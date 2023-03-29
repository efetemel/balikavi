import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/models/AppSettings.dart';
import 'package:balikavi/models/SignUpModel.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/views/SignInView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class SignUpView extends StatelessWidget {
  SignUpView({Key? key}) : super(key: key);

  final String middleText = "Ne bekliyorsun haydi!";

  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var rpasswordController = TextEditingController();
  var birthDatePicker = DateTime(DateTime.now().year - 5).obs;

  void handleSignUp(){
      if(userNameController.text.trim().isNotEmpty && emailController.text.trim().isEmail && passwordController.text.trim().isNotEmpty && passwordController.text.trim() == rpasswordController.text.trim() && passwordController.text.trim().length >= 6){
        var signUpModel = SignUpModel.fromJson({
          "email":emailController.text.trim(),
          "password":passwordController.text.trim(),
          "userName":userNameController.text.trim(),
          "profilePhoto":"default",
          "birthDate":birthDatePicker.value.toString(),
          "description":"beni bilen bilir"
        });
        UserController.instance.signUp(signUpModel);
      }
      else{
        AppUtils.showNotification("Kayıt olma işlemi", "Gerekli alanları doldurunuz!");
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
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Kullanıcı Adı",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: userNameController,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "E-posta",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: emailController,
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
                      TextField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: "Tekrar şifre",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: true,
                        controller: rpasswordController,
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: (){
                          showDatePicker(
                              context: context,
                              initialDate: birthDatePicker.value,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(DateTime.now().year - 5),
                              cancelText: "İptal",
                              confirmText: "Seç",
                              helpText: "Doğum Tarihi Seç",
                          ).then((value) {if(value != null) birthDatePicker.value = value;});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey)

                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                          child: Row(children: [
                            Icon(Icons.cake,color: Colors.grey,),
                            SizedBox(width: 5),
                            Text("Doğum Tarihi:",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                            SizedBox(width: 10),
                            Obx(()=>Text(Jiffy(birthDatePicker.value).yMMMMEEEEd)),
                          ],),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(onPressed: (){handleSignUp();},style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white)), child: Text("Kayıt Ol")),
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
