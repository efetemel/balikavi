class SignInModel {
  String? emailOrUserName;
  String? password;

  SignInModel({this.emailOrUserName, this.password});

  SignInModel.fromJson(Map<String, dynamic> json) {
    emailOrUserName = json['emailOrUserName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailOrUserName'] = this.emailOrUserName;
    data['password'] = this.password;
    return data;
  }
}