class AppSettings {
  bool? firstOpen;
  String? token;

  AppSettings({this.firstOpen,this.token});

  AppSettings.fromJson(Map<String, dynamic> json) {
    firstOpen = json['firstOpen'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstOpen'] = this.firstOpen;
    data['token'] = this.token;
    return data;
  }
}