class UserModel {
  String? email;
  String? userName;
  String? profilePhoto;
  String? birthDate;
  String? description;

  UserModel(
      {this.email,
        this.userName,
        this.profilePhoto,
        this.description,
        this.birthDate});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userName = json['userName'];
    profilePhoto = json['profilePhoto'];
    birthDate = json['birthDate'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['userName'] = this.userName;
    data['profilePhoto'] = this.profilePhoto;
    data['birthDate'] = this.birthDate;
    data['description'] = this.description;
    return data;
  }
}