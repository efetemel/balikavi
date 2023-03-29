class UserModel {
  String? email;
  String? userName;
  String? profilePhoto;
  String? birthDate;
  String? description;
  List? friends;
  List? blocks;
  List? latitude;
  List? longitude;

  UserModel(
      {this.email,
        this.userName,
        this.profilePhoto,
        this.description,
        this.birthDate,this.friends,this.blocks,this.latitude,this.longitude});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userName = json['userName'];
    profilePhoto = json['profilePhoto'];
    birthDate = json['birthDate'];
    description = json['description'];
    friends = json['friends'];
    blocks = json['blocks'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['userName'] = this.userName;
    data['profilePhoto'] = this.profilePhoto;
    data['birthDate'] = this.birthDate;
    data['description'] = this.description;
    data['friends'] = this.friends;
    data['blocks'] = this.blocks;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}