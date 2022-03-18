# **HarperDB**

 ![Pub version](https://img.shields.io/badge/Pub-v0.0.1-orange) ![GitHub all releases](https://img.shields.io/github/downloads/HarperDB/harperdb-sdk-flutter/total) ![language](https://img.shields.io/github/languages/count/HarperDB/harperdb-sdk-flutter?color=g&style=plastic) ![lICENCE](https://img.shields.io/badge/Licence-BSD--3-yellow)
<br> 
---
 A package for connecting Flutter with HarperDB

 <br>
 This package provides a way to access HarperDB API database in either SQL or NOSQL format. It is dependent of the http package made by dart-lang. 
 
 
 ## *Installation*
 ---
Open your project and type the code below in your terminal
 ```dart
 flutter pub add harperdb
 ```

### Usage
***
First you have to import the package 
```dart
import 'package:harperdb/harperdb.dart';
```

Next create a variable to store the data you get from your function which must be a future

```dart
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
    var show = await harperJsonQuery(
      // the 'await' will make it waits for data from the api
      'https://flutterharper-colz.harperdbcloud.com', // Url for your databse.
      'flutter', // Instance Username.
      'demo', //Instance Password.
      {
        // Contains the syntax code from HarperDB for operations.
        "operation":
            "search_by_conditions", //this could be 'insert','delete','update','search_by_value' etc
        "schema": "package",
        "table": "user",
        "get_attributes": [
          "*",
        ],
        "conditions": [
          {
            "search_attribute": "Age",
            "search_type": "between",
            "search_value": [8, 29]
          }
        ]
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
```

initialize your function so it starts as the page opens up
```dart
  @override
  void initState() {
    harperAPI = grabber();
    super.initState();
  }
  ```
  
  Finally when you want to display the results in a function, it adviceable to use a futurebuilder to render it when the data has been obtained from the API
  
  ``` dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Accessing the data of the function requires a future builder because the function is 
      a future function and we don't want our page to open before we get the data from the api
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
                    harperData[index]['FirstName'],
                  ),
                  title: Text(
                    harperData[index]['LastName'],
                    textAlign: TextAlign.center,
                  ),
                  trailing: Text(
                    harperData[index]['Age'].toString(),
                  ),
                );
              },
            );
          }
          //What should be  display if all else fails
          else {
            return const Center(
                child: Text(
                    "Something went wrong, it is not from you it is from us"));
          }
        },
      ),
    );
  }
  ```
  
  # **NOTE :**
  The return type of your fucntion is heavily dependent on the function you are carring out. Functions like "insert", "update","upsert" will return Map and not a list, so you only return a list when your function is a search related operation
 
  
