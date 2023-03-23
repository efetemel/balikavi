import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfileView extends StatelessWidget {
   ProfileView({Key? key}) : super(key: key);

  var x = List.generate(30, (index) => null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        title: Text("Profilim"),
      ),
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
              ),
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppUtils.boxNightColor
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Arkadaşlarım",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add))
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(child: ListView.builder(
                          itemCount: x.length,
                          itemBuilder: (_,pos){
                            return ListTile(
                              leading: CircleAvatar(),
                              title: Text("Joh Doe $pos"),
                              trailing: Icon(Icons.message),
                            );
                          },
                        ))
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
