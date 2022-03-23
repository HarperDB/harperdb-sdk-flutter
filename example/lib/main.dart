//This is called depending on the platform app, it could be cupertino for ios and material for dart, This is totally at your discretion
import 'package:flutter/material.dart';
// This is a necessary file to call our custom functions from the HarperDB package
import 'package:harperdb/harperdb.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This is your Url global variable
  final String hDBURL = 'https://hdb-publicdemo.harperdbcloud.com';
  // This is a global variable for your username
  final String hDBUSER = 'HDB_READER';
  // This is a global variable for your password
  final String hDBPASSWORD = 'password';

  //This handles your return type, it could be either a List for search queries or an Map for queries that insert
  late List harperData;

  //Just a future called harperAPI
  late Future harperAPI;

  // This has to be a future function as it would wait for data from the API
  // The return type for the function varies, it can either be a Map or a List depending on the operation you are carrying out

  Future //function type is stated as a future
      <List> // the fucntion will return future in this case but it can also be set to map in other cases, all you have to do is change <List> to <Map<String, dynamic>>
      loadData() //the function name
  async // it has to be asynchronous
  {
    var show = await harperDB(
      //A variable called show is assigned the result ot the function
      hDBURL,
      hDBUSER,
      hDBPASSWORD,
      {"operation": "sql", "sql": "select * from dev.dog"},
    );
    //this shows you if the query ran properly. The result of your search will be shown in the terminal
    debugPrint(
      show.toString(),
    );
    //set the result of the query to your list which will be returned
    setState(() {
      harperData = show;
    });
    // the function type which was stated must be returned
    return harperData;
  }

  //Initialize your function so it runs as the page opens up
  @override
  void initState() {
    harperAPI = loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // the widget is used to show data after it has gotten the result
        future: harperAPI,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //This block of code states what is to happen while waiting for the result from the database, in this case it is meant to show a circular progress widget
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            //This block of code explains what to do when it has gotten the data from the database
            return ListView.builder(
              itemCount: harperData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    harperData[index]['dog_name'],
                  ),
                  title: Text(
                    harperData[index]['owner_name'],
                    textAlign: TextAlign.center,
                  ),
                  trailing: Text(
                    harperData[index]['dog_age'].toString(),
                  ),
                );
              },
            );
          } else {
            //This block of code will tell what to do if theres an error
            return const Center(child: Text("Something went wrong."));
          }
        },
      ),
    );
  }
}
