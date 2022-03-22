import 'package:flutter/material.dart';
import 'package:harperdb/harperdb.dart';

const HDB_URL = 'http://localhost:9925';
const HDB_USER = 'HDB_ADMIN';
const HDB_PASSWORD = 'password';

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
  late List harperData;
  late Future harperAPI;

  // This has to be a future function as it would wait for data from the API
  // The return type for the function varies, it can either be a Map or a list depending on the operation you are carrying out

  Future<List> grabber() async {
    //function must be async and the <List> shows that it should return a list
    var show = await harperDB(
      HDB_URL,
      HDB_USER,
      HDB_PASSWORD,
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
      body: FutureBuilder(
        future: harperAPI,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
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
          else {
            return const Center(
                child: Text("Something went wrong."));
          }
        },
      ),
    );
  }
}
