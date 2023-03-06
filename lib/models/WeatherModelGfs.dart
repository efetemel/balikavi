class WeatherModelGfs {
  List<int>? ts;
  Units? units;
  List<dynamic>? windUSurface;
  List<dynamic>? windU800h;
  List<dynamic>? windU300h;
  List<dynamic>? windVSurface;
  List<dynamic>? windV800h;
  List<dynamic>? windV300h;
  List<dynamic>? gustSurface;
  List<dynamic>? dewpointSurface;
  List<dynamic>? dewpoint800h;
  List<dynamic>? dewpoint300h;
  List<dynamic>? pressureSurface;
  List<dynamic>? tempSurface;
  List<dynamic>? temp800h;
  List<dynamic>? temp300h;
  List<int>? past3hprecipSurface;
  List<int>? past3hconvprecipSurface;
  List<dynamic>? lcloudsSurface;
  List<int>? mcloudsSurface;
  List<int>? hcloudsSurface;
  List<int>? ptypeSurface;
  List<dynamic>? capeSurface;
  List<dynamic>? rhSurface;
  List<dynamic>? rh800h;
  List<dynamic>? rh300h;
  List<dynamic>? gh800h;
  List<dynamic>? gh300h;

  WeatherModelGfs(
      {this.ts,
        this.units,
        this.windUSurface,
        this.windU800h,
        this.windU300h,
        this.windVSurface,
        this.windV800h,
        this.windV300h,
        this.gustSurface,
        this.dewpointSurface,
        this.dewpoint800h,
        this.dewpoint300h,
        this.pressureSurface,
        this.tempSurface,
        this.temp800h,
        this.temp300h,
        this.past3hprecipSurface,
        this.past3hconvprecipSurface,
        this.lcloudsSurface,
        this.mcloudsSurface,
        this.hcloudsSurface,
        this.ptypeSurface,
        this.capeSurface,
        this.rhSurface,
        this.rh800h,
        this.rh300h,
        this.gh800h,
        this.gh300h});

  WeatherModelGfs.fromJson(Map<String, dynamic> json) {
    ts = json['ts'].cast<int>();
    units = json['units'] != null ? new Units.fromJson(json['units']) : null;
    windUSurface = json['wind_u-surface'];
    windU800h = json['wind_u-800h'];
    windU300h = json['wind_u-300h'];
    windVSurface = json['wind_v-surface'];
    windV800h = json['wind_v-800h'];
    windV300h = json['wind_v-300h'];
    gustSurface = json['gust-surface'];
    dewpointSurface = json['dewpoint-surface'];
    dewpoint800h = json['dewpoint-800h'];
    dewpoint300h = json['dewpoint-300h'];
    pressureSurface = json['pressure-surface'];
    tempSurface = json['temp-surface'];
    temp800h = json['temp-800h'];
    temp300h = json['temp-300h'];
    past3hprecipSurface = json['past3hprecip-surface'];
    past3hconvprecipSurface = json['past3hconvprecip-surface'];
    lcloudsSurface = json['lclouds-surface'];
    mcloudsSurface = json['mclouds-surface'];
    hcloudsSurface = json['hclouds-surface'];
    ptypeSurface = json['ptype-surface'];
    capeSurface = json['cape-surface'];
    rhSurface = json['rh-surface'];
    rh800h = json['rh-800h'];
    rh300h = json['rh-300h'];
    gh800h = json['gh-800h'];
    gh300h = json['gh-300h'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ts'] = this.ts;
    if (this.units != null) {
      data['units'] = this.units!.toJson();
    }
    data['wind_u-surface'] = this.windUSurface;
    data['wind_u-800h'] = this.windU800h;
    data['wind_u-300h'] = this.windU300h;
    data['wind_v-surface'] = this.windVSurface;
    data['wind_v-800h'] = this.windV800h;
    data['wind_v-300h'] = this.windV300h;
    data['gust-surface'] = this.gustSurface;
    data['dewpoint-surface'] = this.dewpointSurface;
    data['dewpoint-800h'] = this.dewpoint800h;
    data['dewpoint-300h'] = this.dewpoint300h;
    data['pressure-surface'] = this.pressureSurface;
    data['temp-surface'] = this.tempSurface;
    data['temp-800h'] = this.temp800h;
    data['temp-300h'] = this.temp300h;
    data['past3hprecip-surface'] = this.past3hprecipSurface;
    data['past3hconvprecip-surface'] = this.past3hconvprecipSurface;
    data['lclouds-surface'] = this.lcloudsSurface;
    data['mclouds-surface'] = this.mcloudsSurface;
    data['hclouds-surface'] = this.hcloudsSurface;
    data['ptype-surface'] = this.ptypeSurface;
    data['cape-surface'] = this.capeSurface;
    data['rh-surface'] = this.rhSurface;
    data['rh-800h'] = this.rh800h;
    data['rh-300h'] = this.rh300h;
    data['gh-800h'] = this.gh800h;
    data['gh-300h'] = this.gh300h;
    return data;
  }
}


class Units {
  String? windUSurface;
  String? windU800h;
  String? windU300h;
  String? windVSurface;
  String? windV800h;
  String? windV300h;
  String? gustSurface;
  String? dewpointSurface;
  String? dewpoint800h;
  String? dewpoint300h;
  String? pressureSurface;
  String? tempSurface;
  String? temp800h;
  String? temp300h;
  String? past3hprecipSurface;
  String? past3hconvprecipSurface;
  String? lcloudsSurface;
  String? mcloudsSurface;
  String? hcloudsSurface;
  String? ptypeSurface;
  String? capeSurface;
  String? rhSurface;
  String? rh800h;
  String? rh300h;
  String? gh800h;
  String? gh300h;

  Units(
      {this.windUSurface,
        this.windU800h,
        this.windU300h,
        this.windVSurface,
        this.windV800h,
        this.windV300h,
        this.gustSurface,
        this.dewpointSurface,
        this.dewpoint800h,
        this.dewpoint300h,
        this.pressureSurface,
        this.tempSurface,
        this.temp800h,
        this.temp300h,
        this.past3hprecipSurface,
        this.past3hconvprecipSurface,
        this.lcloudsSurface,
        this.mcloudsSurface,
        this.hcloudsSurface,
        this.ptypeSurface,
        this.capeSurface,
        this.rhSurface,
        this.rh800h,
        this.rh300h,
        this.gh800h,
        this.gh300h});

  Units.fromJson(Map<String, dynamic> json) {
    windUSurface = json['wind_u-surface'];
    windU800h = json['wind_u-800h'];
    windU300h = json['wind_u-300h'];
    windVSurface = json['wind_v-surface'];
    windV800h = json['wind_v-800h'];
    windV300h = json['wind_v-300h'];
    gustSurface = json['gust-surface'];
    dewpointSurface = json['dewpoint-surface'];
    dewpoint800h = json['dewpoint-800h'];
    dewpoint300h = json['dewpoint-300h'];
    pressureSurface = json['pressure-surface'];
    tempSurface = json['temp-surface'];
    temp800h = json['temp-800h'];
    temp300h = json['temp-300h'];
    past3hprecipSurface = json['past3hprecip-surface'];
    past3hconvprecipSurface = json['past3hconvprecip-surface'];
    lcloudsSurface = json['lclouds-surface'];
    mcloudsSurface = json['mclouds-surface'];
    hcloudsSurface = json['hclouds-surface'];
    ptypeSurface = json['ptype-surface'];
    capeSurface = json['cape-surface'];
    rhSurface = json['rh-surface'];
    rh800h = json['rh-800h'];
    rh300h = json['rh-300h'];
    gh800h = json['gh-800h'];
    gh300h = json['gh-300h'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wind_u-surface'] = this.windUSurface;
    data['wind_u-800h'] = this.windU800h;
    data['wind_u-300h'] = this.windU300h;
    data['wind_v-surface'] = this.windVSurface;
    data['wind_v-800h'] = this.windV800h;
    data['wind_v-300h'] = this.windV300h;
    data['gust-surface'] = this.gustSurface;
    data['dewpoint-surface'] = this.dewpointSurface;
    data['dewpoint-800h'] = this.dewpoint800h;
    data['dewpoint-300h'] = this.dewpoint300h;
    data['pressure-surface'] = this.pressureSurface;
    data['temp-surface'] = this.tempSurface;
    data['temp-800h'] = this.temp800h;
    data['temp-300h'] = this.temp300h;
    data['past3hprecip-surface'] = this.past3hprecipSurface;
    data['past3hconvprecip-surface'] = this.past3hconvprecipSurface;
    data['lclouds-surface'] = this.lcloudsSurface;
    data['mclouds-surface'] = this.mcloudsSurface;
    data['hclouds-surface'] = this.hcloudsSurface;
    data['ptype-surface'] = this.ptypeSurface;
    data['cape-surface'] = this.capeSurface;
    data['rh-surface'] = this.rhSurface;
    data['rh-800h'] = this.rh800h;
    data['rh-300h'] = this.rh300h;
    data['gh-800h'] = this.gh800h;
    data['gh-300h'] = this.gh300h;
    return data;
  }
}

