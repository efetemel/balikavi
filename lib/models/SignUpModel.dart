class SignUpModel {
  String? email;
  String? password;
  String? userName;
  String? profilePhoto;
  String? birthDate;
  String? description;


  SignUpModel(
      {this.email,
        this.password,
        this.userName,
        this.profilePhoto,
        this.description,
        this.birthDate});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    userName = json['userName'];
    profilePhoto = json['profilePhoto'];
    birthDate = json['birthDate'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['userName'] = this.userName;
    data['profilePhoto'] = this.profilePhoto;
    data['birthDate'] = this.birthDate;
    data['description'] = this.description;
    return data;
  }
}