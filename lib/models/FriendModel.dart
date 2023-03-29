class FriendModel {
  String? userId;
  String? userName;
  String? profilePhoto;

  FriendModel({this.userId, this.userName, this.profilePhoto});

  FriendModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    profilePhoto = json['profilePhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['profilePhoto'] = this.profilePhoto;
    return data;
  }
}