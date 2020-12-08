import 'package:flutter/material.dart';

import 'package:productos/addProduct/addProduct.dart';
import 'package:productos/DatabaseOperation/databaseData.dart';
import 'package:productos/ComponentHome/CreateComponent.dart';
import 'package:productos/DatabaseOperation/Task.dart';

void main() {
  runApp(MyApp());
}

//this is the principal class

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: mainPage(),
    );
  }
}

// ignore: camel_case_types
class mainPage extends StatefulWidget {
  @override
  _mainComponent createState() => _mainComponent();
}

// ignore: camel_case_types
class _mainComponent extends State<mainPage> {
  DatabaseData db = DatabaseData();
  bool _isSearching = false;
  String valNew = "";
  // ignore: non_constant_identifier_names
  TextEditingController ContentSearch = TextEditingController();
  Route _handleNavigationPressed() {
    return PageRouteBuilder(
      transitionDuration: const Duration(
        milliseconds: 500,
      ),
      pageBuilder: (context, animation, secondaryAnimation) => AddProduct(
        db: db,
        callbackInsert: callbackInsert,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget _getAppBarNotSearching(String title) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.purple,
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _startSearching();
            }),
      ],
    );
  }

  Widget _getAppBarSearching() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.purple,
      iconTheme: IconThemeData(color: Colors.white),
      leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _cancelSearching();
          }),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 0, right: 10),
        child: TextField(
          controller: ContentSearch,
          onChanged: (String val) {
            if (_isSearching) {
              setState(() {
                valNew = val;
              });
            }
          },
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
          cursorColor: Colors.white,
          autofocus: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            focusColor: Colors.white,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
          ),
        ),
      ),
    );
  }

  void _startSearching() {
    setState(() {
      _isSearching = true;
      ContentSearch.clear();
    });
  }

  void _cancelSearching() {
    setState(() {
      _isSearching = false;
      valNew = "";
      ContentSearch.clear();
    });
  }

  Map<String, dynamic> _convertToMap(
      int id, String name, double price, String detail, int amount) {
    return {
      "id": id,
      "name": name,
      "price": price,
      "detailarticle": detail,
      "amount": amount
    };
  }

  void callbackDelete(int id) {
    setState(() {
      db.deleteProduct(id);
    });
  }

  void callbackInsert(Task dataInsert) {
    setState(() {
      db.insertProduct(dataInsert);
      if (_isSearching) {
        valNew = "";
        _isSearching = false;
      }
    });
  }

  void callbackUpdate(Task dataUpdate) {
    setState(() {
      db.updateProduct(dataUpdate);
      if (_isSearching) {
        valNew = "";
        _isSearching = false;
      }
    });
  }

  _showList(BuildContext context) {
    return FutureBuilder(
      future: db.getSpecifiedList(valNew),
      initialData: List<Task>(),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            padding: EdgeInsets.all(15.0),
            children: [
              for (Task task in snapshot.data)
                CreateComponent(
                  dataComponent: _convertToMap(
                      task.id, task.name, task.price, task.detail, task.amount),
                  db: db,
                  callbackDelete: callbackDelete,
                  callbackUpdate: callbackUpdate,
                ),
            ],
          );
        } else {
          return Center(child: Text("Agrega datos"));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching
          ? _getAppBarSearching()
          : _getAppBarNotSearching("Productos"),
      body: SafeArea(
        child: FutureBuilder(
          future: db.initDB(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _showList(context);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(_handleNavigationPressed());
        },
        backgroundColor: Colors.pink[600],
        tooltip: 'Agregar producto',
        child: Icon(Icons.add),
      ),
    );
  }
}
