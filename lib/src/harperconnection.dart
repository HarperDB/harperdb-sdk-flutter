// this import handles the jsonEncode and Decode
import 'dart:convert';
// This happpens to be the most important package as it is used to connect to the cloud database via internet
import 'package:http/http.dart' as http;

//This is a future function as we must await response from the database server
Future harperDB(
  //The name of the function 'harperDB' is what is called in our main.dart or the page where we want to access our database
  String
      harperurl, //This is the valid url to your database for example (https://xyz.harperdbcloud.com)
  String instanceUsername, // this is the username of your instance in flutter
  String
      instancePassword, // this is the password the instance you created to store your database.
  Map<String, dynamic>
      operation, // This exectues a list of operation you would like to be carried out, examples of operations can be found at https://studio.harperdb.io/resources/examples/NoSQL%20Operations/Search%20By%20Conditions and a video to explain NOSQL AND SQL can be found at https://youtu.be/oJuoddPPVYs
) async {
  // The function has to be asynchronous as we are going to be waiting from data from the database
  String signingDetails =
      '$instanceUsername:$instancePassword'; //This will combine the username and password together, if for example your username is 'Hello' and your password is 'World'. it will then form 'Hello:World'
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String authcode = stringToBase64.encode(signingDetails);
  var url = Uri.parse(harperurl);
  var response = await http.post(
      //Here we ar making use of the API details we have provided to authenticate and ask for the data we want to get from our database and we wait for the data then put it in the variable called response
      url, //First we need the url, This is a variable which links to the harperurl we gave in line 8
      headers: <String, String>{
        //This section handles the authentication and return type of the data we are sending
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Basic $authcode'
      },
      body: jsonEncode(
          operation)); //Now here comes the crucial part where we write operation like search for username, insert user data, etc. whatever operations you would perform would be placed in the operations section
  var result = jsonDecode(response
      .body); //Now we have gotten the result after waiting for the data, we then decode the data and also put it in a variable called result
  return result; //This is returned whenever the function is calle
}
