# **HarperDB**

 ![Pub version](https://img.shields.io/badge/Pub-v0.0.1-orange) ![GitHub all releases](https://img.shields.io/github/downloads/HarperDB/harperdb-sdk-flutter/total) ![language](https://img.shields.io/github/languages/count/HarperDB/harperdb-sdk-flutter?color=g&style=plastic) ![lICENCE](https://img.shields.io/badge/Licence-BSD--3-yellow)
<br> 
---
 A package for connecting Flutter with HarperDB. Its only dependency is the http package by dart-lang. 
 
 
 ## *Installation*
 ---
Open your project and type the code below in your terminal
 ```dart
 flutter pub add harperdb
 ```

### Usage
***
Import the package 
```dart
import 'package:harperdb/harperdb.dart';
```

Set your HDB_URL, HDB_USER, and HDB_PASSWORD variables for use within your application:

```dart
const HDB_URL = 'https://hdb-publicdemo.harperdbcloud.com';
const HDB_USER = 'HDB_READER';
const HDB_PASSWORD = 'password';
```

Build your function (must have async type of Future):

```dart
  // Function must be async
  // Use <List> return for queries.
  // Use <Map> for inserts, updates, deletes, etc.
  
  Future<List> loadData() async {
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
```

Call your function on init:

```dart
  @override
  void initState() {
    queryHarperDB = loadData();
    super.initState();
  }
  ```
  
To display the results of your query, use a FutureBuilder to ensure the data has returned from the API:
  
  ``` dart
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          body: FutureBuilder(
            future: queryHarperDB,
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
  ```
  
  # **NOTE :**
  The return type of your function is dependent on the HarperDB operation you are executing. Queries will return a &lt;List&gt;, while inserts, updates, deletes, etc. will return a &lt;Map&gt;
