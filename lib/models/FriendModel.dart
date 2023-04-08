class FriendModel {
  String? userId;
  String? userName;
  String? profilePhoto;
  String? description;
  bool? lastSeen;
  bool? online;
  String? lastOnline;
  String? id;


  FriendModel({this.userId, this.userName, this.profilePhoto,this.description,this.online,this.lastSeen,this.lastOnline,this.id});

  FriendModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    profilePhoto = json['profilePhoto'];
    description = json['description'];
    lastSeen = json['lastSeen'];
    online = json['online'];
    lastOnline = json['lastOnline'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['profilePhoto'] = this.profilePhoto;
    data['description'] = this.description;
    data['lastSeen'] = this.lastSeen;
    data['online'] = this.online;
    data['lastOnline'] = this.lastOnline;
    data['id'] = this.id;
    return data;
  }
}