import 'package:flutter/material.dart';

import 'package:productos/databaseData.dart';

class AddProduct extends StatefulWidget {
  DatabaseData db;
  Function callbackInsert;
  AddProduct({
    Key key,
    this.db,
    this.callbackInsert,
  });
  @override
  UIAddProduct createState() => UIAddProduct();
}

class UIAddProduct extends State<AddProduct> {
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
            FormAdd(db: widget.db, callbackInsert: widget.callbackInsert),
          ]),
        ));
  }
}

class FormAdd extends StatefulWidget {
  final DatabaseData db;
  Function callbackInsert;
  FormAdd({Key key, this.db, this.callbackInsert});
  @override
  ContentForm createState() => ContentForm();
}

Widget _boxTextField(String placeholder, TextEditingController controller,
        TextInputType typeData) =>
    TextFormField(
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return 'Rellena el campo';
        }
        return null;
      },
      style: TextStyle(
        fontSize: 20,
      ),
      decoration: InputDecoration(hintText: placeholder),
      textAlign: TextAlign.center,
      keyboardType: typeData,
    );

class ContentForm extends State<FormAdd> {
  final _formKey = GlobalKey<FormState>();
  String titleAvatar = "";

  Map<String, TextEditingController> controllerForm = {
    "id": TextEditingController(),
    "name": TextEditingController(),
    "price": TextEditingController(),
    "detailarticle": TextEditingController(),
    "amount": TextEditingController()
  };
  void _changedCircleAvatarName() {
    setState(() {
      if (controllerForm['name'].text != "") {
        titleAvatar = controllerForm['name'].text[0].toUpperCase();
      } else {
        titleAvatar = "";
      }
    });
  }

  void _returnMainPage(BuildContext context) {
    Navigator.of(context).pop(this);
  }

  _insertDB() {
    var task = Task(555555, "Chocolate", 12.2, "Muy delicioso", 12);
    widget.callbackInsert(task);
    //widget.db.insertProduct(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    color: Colors.blue[900],
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: 50.0,
                      child: Text(
                        titleAvatar,
                        style: TextStyle(fontSize: 40, color: Colors.black),
                      ),
                    )),
                _boxTextField(
                    "Clave", controllerForm['id'], TextInputType.number),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controllerForm['name'],
                  onChanged: (String val) => {
                    _changedCircleAvatarName(),
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Rellena los campos';
                    }
                    return null;
                  },
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(hintText: "Nombre"),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 10,
                ),
                _boxTextField(
                    "Precio", controllerForm['price'], TextInputType.number),
                SizedBox(
                  height: 10,
                ),
                _boxTextField("Detalle del producto",
                    controllerForm['detailarticle'], TextInputType.text),
                SizedBox(
                  height: 10,
                ),
                _boxTextField(
                    "Cantidad", controllerForm['amount'], TextInputType.number),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  color: Colors.purple[900],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => {
                    if (_formKey.currentState.validate())
                      {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data'))),
                        _insertDB(),
                      }
                  },
                ),
                RaisedButton(
                  color: Colors.pink[700],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => {_returnMainPage(context)},
                ),
              ],
            )),
        //)
      ),
    );
  }
}
