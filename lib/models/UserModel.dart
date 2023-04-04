import 'package:balikavi/models/PositionsModel.dart';

class UserModel {
  String? email;
  String? userName;
  String? profilePhoto;
  String? birthDate;
  String? description;
  List? friends;
  List? blocks;
  List? requests;
  List<PositionsModel>? positions;

  UserModel(
      {this.email,
        this.userName,
        this.profilePhoto,
        this.description,
        this.birthDate,this.friends,this.blocks,this.positions,this.requests});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userName = json['userName'];
    profilePhoto = json['profilePhoto'];
    birthDate = json['birthDate'];
    description = json['description'];
    friends = json['friends'];
    blocks = json['blocks'];
    requests = json['requests'];
    List<PositionsModel> posList = [];
    var x = json["positions"] as List;
    x.forEach((element) {
      posList.add(PositionsModel(latitude: element[0],longitude: element[1]));
    });
    positions = posList;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['userName'] = this.userName;
    data['profilePhoto'] = this.profilePhoto;
    data['birthDate'] = this.birthDate;
    data['description'] = this.description;
    data['requests'] = this.requests;
    if(this.friends != null) {
      data['friends'] = this.friends;
    } else {
      data['friends'] = [];
    }
    if(this.blocks != null) {
      data['blocks'] = this.blocks;
    }
    else{
      data["blocks"] = [];
    }
    try{
      data['positions'] = this.positions as List<PositionsModel>;
    }catch(err){
      data['positions'] = this.positions;
    }
    return data;
  }
}