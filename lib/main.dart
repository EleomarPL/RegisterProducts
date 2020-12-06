import 'package:flutter/material.dart';

import 'package:productos/addProduct.dart';
import 'package:productos/databaseData.dart';
import 'package:productos/updateProduct.dart';

void main() {
  runApp(MyApp());
}

//this is the principal class

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
                borderSide: BorderSide(color: Colors.blue)),
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
      db.insert(dataInsert);
    });
  }

  void callbackUpdate(Task dataUpdate) {
    setState(() {
      db.updateProduct(dataUpdate);
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
          return Center(
            child: Text("Agrega datos"),
          );
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
                child: Text("No hay"),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(_handleNavigationPressed());
          print("regreso");
        },
        tooltip: 'Agregar producto',
        child: Icon(Icons.add),
      ),
    );
  }
}

// ignore: must_be_immutable
class CreateComponent extends StatefulWidget {
  final Map<String, dynamic> dataComponent;
  final DatabaseData db;
  Function callbackDelete;
  Function callbackUpdate;
  CreateComponent(
      {Key key,
      this.dataComponent,
      this.db,
      this.callbackDelete,
      this.callbackUpdate})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreateComponentState();
}

class _CreateComponentState extends State<CreateComponent> {
  Widget _customText(String texto, FontWeight fontWeight, double fontsize) =>
      Text(
        texto,
        style: TextStyle(
          fontSize: fontsize,
          fontWeight: fontWeight,
        ),
      );
  Widget dividerColumnText() => Divider(
        color: Colors.blue[300],
        height: 10,
        thickness: 2,
      );
  Route _handleNavigationPressedUpdate() {
    return PageRouteBuilder(
      transitionDuration: const Duration(
        milliseconds: 500,
      ),
      pageBuilder: (context, animation, secondaryAnimation) => UpdateProduct(
          dataMainPage: widget.dataComponent,
          db: widget.db,
          callbackUpdate: widget.callbackUpdate),
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

  _updateComponent(BuildContext context) {
    widget.callbackDelete(widget.dataComponent['id']);
    Navigator.pop(context);
  }

  _deleteProduct(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                          "¿Esta seguro que desea eliminar este producto?"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          color: Colors.blue[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          child: Text(
                            'Si',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () => {_updateComponent(context)},
                        ),
                        RaisedButton(
                          color: Colors.blue[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () => {
                            Navigator.pop(context),
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            color: Colors.purple[900],
            child: Column(children: [
              SizedBox(
                height: 15,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: 60.0,
                      child: Text(
                        "${widget.dataComponent['name'][0]}".toUpperCase(),
                        style: TextStyle(fontSize: 70.0, color: Colors.black),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Flexible(
                    flex: 15,
                    child: Container(
                      color: Colors.white,
                      //child: Center(
                      //padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: _customText(
                                    " id: ${widget.dataComponent['id']}",
                                    FontWeight.bold,
                                    14),
                              ),
                              Flexible(
                                child: IconButton(
                                    color: Colors.red,
                                    iconSize: 35,
                                    icon: Icon(Icons.cancel),
                                    onPressed: () {
                                      _deleteProduct(context);
                                    }),
                              ),
                            ],
                          ),
                          dividerColumnText(),
                          _customText(" ${widget.dataComponent['name']}",
                              FontWeight.bold, 17),
                          dividerColumnText(),
                          _customText(" \$${widget.dataComponent['price']}",
                              FontWeight.normal, 17),
                          dividerColumnText(),
                          _customText(
                              " Detalle: ${widget.dataComponent['detailarticle']}",
                              FontWeight.normal,
                              17),
                          dividerColumnText(),
                          _customText(
                              " Cantidad: ${widget.dataComponent['amount']}",
                              FontWeight.normal,
                              17),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      //),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ]),
          ),
          onTap: () {
            Navigator.of(context).push(_handleNavigationPressedUpdate());
          },
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
