class SunSetAndRiseModel {
  String? sunrise;
  String? sunset;
  String? solarNoon;
  int? dayLength;
  String? civilTwilightBegin;
  String? civilTwilightEnd;
  String? nauticalTwilightBegin;
  String? nauticalTwilightEnd;
  String? astronomicalTwilightBegin;
  String? astronomicalTwilightEnd;

  SunSetAndRiseModel(
      {this.sunrise,
        this.sunset,
        this.solarNoon,
        this.dayLength,
        this.civilTwilightBegin,
        this.civilTwilightEnd,
        this.nauticalTwilightBegin,
        this.nauticalTwilightEnd,
        this.astronomicalTwilightBegin,
        this.astronomicalTwilightEnd});

  SunSetAndRiseModel.fromJson(Map<String, dynamic> json) {
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    solarNoon = json['solar_noon'];
    dayLength = json['day_length'];
    civilTwilightBegin = json['civil_twilight_begin'];
    civilTwilightEnd = json['civil_twilight_end'];
    nauticalTwilightBegin = json['nautical_twilight_begin'];
    nauticalTwilightEnd = json['nautical_twilight_end'];
    astronomicalTwilightBegin = json['astronomical_twilight_begin'];
    astronomicalTwilightEnd = json['astronomical_twilight_end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['solar_noon'] = this.solarNoon;
    data['day_length'] = this.dayLength;
    data['civil_twilight_begin'] = this.civilTwilightBegin;
    data['civil_twilight_end'] = this.civilTwilightEnd;
    data['nautical_twilight_begin'] = this.nauticalTwilightBegin;
    data['nautical_twilight_end'] = this.nauticalTwilightEnd;
    data['astronomical_twilight_begin'] = this.astronomicalTwilightBegin;
    data['astronomical_twilight_end'] = this.astronomicalTwilightEnd;
    return data;
  }
}