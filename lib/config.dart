import 'dart:convert';

getApiUrl() {

  return "http://SERVERIP:PORT/v1";
}

getbase64Authentication()
{
  String authettusername = "ibrahim";
  String authettpass = "41";
  return 'Basic ' + base64Encode(utf8.encode('$authettusername:$authettpass'));
}