import 'dart:convert';
import 'package:http/http.dart' as http;

Future harperDB(
  String harperurl,
  String instanceUsername,
  String instancePassword,
  Map<String, dynamic> operation,
) async {
  String signingDetails = '$instanceUsername:$instancePassword';
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String authcode = stringToBase64.encode(signingDetails);
  var url = Uri.parse(harperurl);
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Basic $authcode'
      },
      body: jsonEncode(operation));
  var result = jsonDecode(response.body);
  return result;
}
