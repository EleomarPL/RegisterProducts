import 'package:flutter/material.dart';
import 'Form/FormData.dart';
import '../ReusableComponents/TitleWindows.dart';
import '../DatabaseOperation/DatabaseData.dart';

class AddProduct extends StatefulWidget {
  final DatabaseData db;
  final Function callbackInsert;
  AddProduct({
    Key key,
    this.db,
    this.callbackInsert,
  });

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return TitleWindow(
      title: 'Agregar producto',
      body: FormData(
        db: widget.db,
        callback: widget.callbackInsert,
      ),
    );
  }
}
