class FriendModel {
  String? userId;
  String? userName;
  String? profilePhoto;
  String? description;

  FriendModel({this.userId, this.userName, this.profilePhoto,this.description});

  FriendModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    profilePhoto = json['profilePhoto'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['profilePhoto'] = this.profilePhoto;
    data['description'] = this.description;
    return data;
  }
}