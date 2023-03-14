class PositionsModel{
  double? latitude;
  double? longitude;

  PositionsModel({this.latitude,this.longitude});

  PositionsModel.fromJson(Map<String,dynamic> json){
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }

}