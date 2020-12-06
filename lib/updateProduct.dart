import 'package:flutter/material.dart';

import 'package:productos/databaseData.dart';

// ignore: camel_case_types
class UpdateProduct extends StatelessWidget {
  final Map<String, dynamic> dataMainPage;
  DatabaseData db;
  Function callbackUpdate;
  UpdateProduct({
    Key key,
    this.dataMainPage,
    this.db,
    this.callbackUpdate,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Actualizar producto'),
          //backgroundColor: Colors.white,
          //iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child:
              ListView(padding: EdgeInsets.symmetric(vertical: 8.0), children: [
            FormAdd(
              dataArticle: dataMainPage,
              db: db,
              callbackUpdate: callbackUpdate,
            ),
          ]),
        ));
  }
}

class FormAdd extends StatefulWidget {
  final Map<String, dynamic> dataArticle;
  final DatabaseData db;
  Function callbackUpdate;
  FormAdd({Key key, this.dataArticle, this.db, this.callbackUpdate})
      : super(key: key);
  @override
  ContentForm createState() => ContentForm();
}

Widget _boxTextField(String placeholder, TextEditingController controllerText,
        TextInputType typeData, bool isEnabled) =>
    TextFormField(
      controller: controllerText,
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
      enabled: isEnabled,
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
  void initState() {
    super.initState();
    titleAvatar = "${widget.dataArticle['name'][0]}".toString();
    controllerForm['name'].text = "${widget.dataArticle['name']}";
    controllerForm['id']..text = "${widget.dataArticle['id']}";
    controllerForm['price']..text = "${widget.dataArticle['price']}";
    controllerForm['detailarticle']
      ..text = "${widget.dataArticle['detailarticle']}";
    controllerForm['amount']..text = "${widget.dataArticle['amount']}";
    controllerForm['name'].addListener(() {
      final text = controllerForm['name'].text.toLowerCase();
      controllerForm['name'].value = controllerForm['name'].value.copyWith(
            text: text,
            selection: TextSelection(
                baseOffset: text.length, extentOffset: text.length),
            composing: TextRange.empty,
          );
    });
  }

  void _changedCircleAvatarName(String val) {
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

  void _updateProduct(BuildContext context) {
    var taskUpdate = Task(
        widget.dataArticle['id'],
        "nuevo nombre",
        widget.dataArticle['price'],
        widget.dataArticle['detailarticle'],
        widget.dataArticle['amount']);
    widget.callbackUpdate(taskUpdate);
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
                    "Clave", controllerForm['id'], TextInputType.number, false),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controllerForm['name'],
                  onChanged: (String val) => {
                    if (val.length <= 1)
                      {
                        _changedCircleAvatarName(val),
                      }
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
                  decoration: const InputDecoration(
                    hintText: "Nombre",
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 10,
                ),
                _boxTextField("Precio", controllerForm['price'],
                    TextInputType.number, true),
                SizedBox(
                  height: 10,
                ),
                _boxTextField("Detalle del producto",
                    controllerForm['detailarticle'], TextInputType.text, true),
                SizedBox(
                  height: 10,
                ),
                _boxTextField("Cantidad", controllerForm['amount'],
                    TextInputType.number, true),
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
                    'Actualizar',
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
                        _updateProduct(context),
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
