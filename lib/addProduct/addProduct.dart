import 'package:flutter/material.dart';

import 'package:productos/DatabaseOperation/databaseData.dart';

import 'package:productos/addProduct/FormAdd.dart';

// ignore: must_be_immutable
class AddProduct extends StatelessWidget {
  DatabaseData db;
  Function callbackInsert;
  AddProduct({
    Key key,
    this.db,
    this.callbackInsert,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Agregar producto'),
        ),
        body: SafeArea(
          child:
              ListView(padding: EdgeInsets.symmetric(vertical: 8.0), children: [
            FormAdd(db: db, callbackInsert: callbackInsert),
          ]),
        ));
  }
}
