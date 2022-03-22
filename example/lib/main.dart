import 'package:flutter/material.dart';
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
  // https://flutterharper-colz.harperdbcloud.com

  // SCHEMA - package

  //Table - user

  // The return type is a list and it is initialed late because it waits for the api to retrieve data before it is initialized

  late List harperData;

  late Future harperAPI;

  // This has to be a future function as it would wait for data from the API
  // The return type for the function varies, it can either be a Map or a list depending on the operation you are carrying out

  Future<List> grabber() async {
    //function must be async and the <List> shows that it should return a list
    var show = await harperDB(
      // the 'await' will make it waits for data from the api
      'http://localhost:9925', // Url for your databse.
      'HDB_ADMIN', // Instance Username.
      'password', //Instance Password.
      {
        // Contains the syntax code from HarperDB for operations.
        "operation": "sql",
        "sql": "select * from dev.dog"
      },
    );
    //this shows you if the query ran properly
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
    harperAPI = grabber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Accessing the data of the function requires a future builder because the function is a future function and we don't want our page to open before we get the data from the api
      body: FutureBuilder(
        future: harperAPI,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //what happens when the page is still waiting for data from the API
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // What happens when the data is received from the API
          else if (snapshot.connectionState == ConnectionState.done) {
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
          }
          //What should be  display if all else fails
          else {
            return const Center(
                child: Text("Something went wrong."));
          }
        },
      ),
    );
  }
}
