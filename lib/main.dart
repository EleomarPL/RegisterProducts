import 'package:flutter/material.dart';
import 'ReusableComponents/Transition.dart';
import 'AddUpdate/AddProduct.dart';
import 'Debouncer/Debouncer.dart';
import 'DatabaseOperation/Product.dart';

import 'DatabaseOperation/DatabaseData.dart';
import 'ComponentHome/CreateComponent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

// ignore: camel_case_types
class MainPage extends StatefulWidget {
  @override
  _MainComponent createState() => _MainComponent();
}

// ignore: camel_case_types
class _MainComponent extends State<MainPage> {
  DatabaseData db = DatabaseData();
  bool _isSearching = false;
  String valNew = "";

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
    final debouncer = Debouncer();
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
          onChanged: (String val) {
            if (_isSearching) {
              debouncer.run(() {
                setState(() {
                  valNew = val;
                });
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
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  void _startSearching() {
    setState(() {
      _isSearching = true;
    });
  }

  void _cancelSearching() {
    setState(() {
      _isSearching = false;
      valNew = "";
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

  void callbackInsert(Product dataInsert) {
    setState(() {
      db.insertProduct(dataInsert);
      if (_isSearching) {
        valNew = "";
        _isSearching = false;
      }
    });
  }

  void callbackUpdate(Product dataUpdate) {
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
      initialData: List<Product>(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData && snapshot.data.length != 0) {
          return ListView(
            padding: EdgeInsets.all(15.0),
            children: [
              for (Product task in snapshot.data)
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
          return (_isSearching)
              ? Center(child: Text("Sin resultados"))
              : Center(child: Text("Agregue un producto"));
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
          Navigator.of(context).push(
            Transition.handleNavigationPressed(
              AddProduct(
                db: db,
                callbackInsert: callbackInsert,
              ),
            ),
          );
        },
        backgroundColor: Colors.pink[600],
        tooltip: 'Agregar producto',
        child: Icon(Icons.add),
      ),
    );
  }
}
