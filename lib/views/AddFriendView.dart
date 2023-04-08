import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/models/FriendModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/AppUtils.dart';

class AddFriendView extends StatelessWidget {

  var searchTextController = TextEditingController();
  AddFriendView(){
    searchTextController.clear();
    UserController.instance.searchedFriends.value = [];
    UserController.instance.searchedFriends.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arkadaş ekle"),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child:Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppUtils.boxNightColor
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: TextField(
                          controller: searchTextController,
                          onSubmitted: (_)async{ //await WeatherController.instance.searchLocation(searchTextController.text);
                          },
                          decoration: InputDecoration(
                            suffixIcon:IconButton(onPressed: ()async{
                              await UserController.instance.searchFriends(searchTextController);
                            }, icon: Icon(Icons.search)),
                            hintText: "Kullcını adı arama yap",
                          ))),
                    ]
                ),
              ),
              Expanded(
                child: Obx(()=>ListView.builder(
                  itemCount: UserController.instance.searchedFriends.value.length,
                  itemBuilder: (_,int pos){
                    return ListTile(
                      leading: CircleAvatar(child: Text(UserController.instance.searchedUserList[pos].userName!.substring(0,1).toUpperCase())),
                      title: Text(UserController.instance.searchedUserList[pos].userName!),
                      trailing: const Text("İstek gönder"),
                      onTap: ()async{
                        await UserController.instance.addFriendAddPending(UserController.instance.searchedUserList[pos].userId!);
                       // await UserController.instance.sendFriendRequest(UserController.instance.searchedUserList[pos].userId!);
                      },
                    );
                  },
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
