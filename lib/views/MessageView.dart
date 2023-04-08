import 'package:balikavi/controllers/UserController.dart';
import 'package:balikavi/models/MessageModel.dart';
import 'package:balikavi/widgets/MyMessageBallon.dart';
import 'package:balikavi/widgets/OtherMessageBallon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jiffy/jiffy.dart';

class MessageView extends StatelessWidget {
  String receiverId;
  final ScrollController _scrollController = ScrollController();

  MessageView(this.receiverId, {super.key}){

    //UserController.instance.sendHelloMessage(UserController.instance.user.value!.uid, receiverId);
  }

  var messageText = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var user = UserController.instance.friendList.singleWhere((p0) => p0.userId == receiverId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          children: [
            CircleAvatar(child: Text(user.userName!.substring(0,1).toUpperCase())),
            SizedBox(width:10),
            Text(user.userName!)
          ],
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz))
        ],
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(child: StreamBuilder(
              stream: UserController.instance.firestore.collection("users").doc(UserController.instance.user.value!.uid).collection("messages").orderBy("sendTime").snapshots(),
              builder: (_,AsyncSnapshot<QuerySnapshot> snap){
                if(snap.hasData){
                  var p = snap.data!.docs.where((element) => element.get("receiverId") == receiverId || element.get("senderId") == receiverId);
                  WidgetsBinding.instance
                      .addPostFrameCallback((_){
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: p.length,
                    itemBuilder: (_,int pos){
                      var message = p.toList()[pos];
                      var time = message.get("sendTime") as Timestamp;
                      var toDate = time.toDate();
                      if(message.get("senderId") == UserController.instance.user.value!.uid){
                        return MyMessageBallon(pos, message, toDate);
                      }
                      else{
                        if(message.get("seen") == false){
                          UserController.instance.seenMessage(message.id,receiverId);
                        }
                        return OtherMessageBallon(message, toDate);
                      }
                    },
                  );
                }else{
                  return CircularProgressIndicator();
                }
              },
            )),
            Container(
              height: 45,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageText,
                      onSubmitted: (_)async{
                        await UserController.instance.sendMessage(UserController.instance.user.value!.uid, receiverId, messageText.text, "Text");
                        messageText.clear();
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(icon: Icon(Icons.send),onPressed: ()async{
                            await UserController.instance.sendMessage(UserController.instance.user.value!.uid, receiverId, messageText.text, "Text");
                            messageText.clear();

                          },),
                          contentPadding: EdgeInsets.symmetric(horizontal: 5)
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}