class Links{
  static const String weatherApi = "https://api.windy.com/api/point-forecast/v2";
  static const String weatherApiKey = "0Wpd5CiIdlBfDqhDLpXPhz2zmzafpUIe";

  static const String _myApi = "http://192.168.1.111:3001/api";
  static const String _myApiAuthPrefix = "/auth/";
  static const String myApiSignUp = "$_myApi${_myApiAuthPrefix}signUp";
  static const String myApiSignIn = "$_myApi${_myApiAuthPrefix}signIn";
  static const String myApiGetSettings = "$_myApi${_myApiAuthPrefix}getSettings";
}