import 'package:balikavi/models/PositionsModel.dart';

class AppSettings {
  bool? firstOpen;
  String? token;
  List<double>? lats;
  List<double>? lngs;
  List<PositionsModel>? positions;

  AppSettings({this.firstOpen,this.token,this.positions});

  AppSettings.fromJson(Map<String, dynamic> json) {
    firstOpen = json['firstOpen'];
    token = json['token'];
    List<PositionsModel> posList = [];
    var x = json["positions"] as List;
    x.forEach((element) {
      var y = PositionsModel.fromJson(element);
      posList.add(y);
    });
    positions = posList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstOpen'] = this.firstOpen;
    data['token'] = this.token;
    data['positions'] = this.positions as List<PositionsModel>;
    return data;
  }
}