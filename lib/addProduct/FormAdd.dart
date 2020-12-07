import 'package:flutter/material.dart';
import 'package:productos/DatabaseOperation/Task.dart';
import 'package:productos/DatabaseOperation/databaseData.dart';

int resultId;

// ignore: must_be_immutable
class FormAdd extends StatefulWidget {
  final DatabaseData db;
  Function callbackInsert;
  FormAdd({Key key, this.db, this.callbackInsert});
  @override
  ContentForm createState() => ContentForm();
}

Widget _boxTextField(String placeholder, TextEditingController controllerText,
        TextInputType typeData, DatabaseData db) =>
    TextFormField(
      controller: controllerText,
      validator: (value) {
        if (typeData == TextInputType.number) {
          if (value.isEmpty) {
            return "Rellene el campo";
          } else {
            switch (placeholder) {
              case 'Clave':
              case 'Cantidad':
                var valueData = int.tryParse(value);
                return (value.length > 18)
                    ? "Maximo 17 caracteres"
                    : ((valueData == null) ? "Digite un numero entero" : null);
                break;
              case 'Precio':
                var valueData = double.tryParse(value);
                return (value.length > 18)
                    ? "Maximo 17 caracteres"
                    : ((valueData == null) ? "Digite un numero decimal" : null);
                break;
            }
          }
        } else {
          return (value.trim().isEmpty) ? 'Rellena el campo' : null;
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
  void _changedCircleAvatarName(String val) {
    setState(() {
      titleAvatar = (val != "") ? val[0].toUpperCase() : "";
    });
  }

  void _returnMainPage(BuildContext context) {
    Navigator.of(context).pop(this);
  }

  _insertDB() {
    var task;
    Future<int> getResultId =
        widget.db.queryId(int.tryParse(controllerForm['id'].text));
    getResultId.then((value) => {
          if (value != null)
            {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 15.0),
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  "Clave repetida, introduzca una clave diferente por favor",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                    color: Colors.blue[400],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        15.0,
                                      ),
                                    ),
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(
                                        fontSize: 15,
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
                  }),
            }
          else
            {
              task = Task(
                  int.tryParse(controllerForm['id'].text),
                  controllerForm['name'].text,
                  double.tryParse(controllerForm['price'].text),
                  controllerForm['detailarticle'].text,
                  int.tryParse(controllerForm['amount'].text)),
              widget.callbackInsert(task),
              Navigator.pop(context),
            }
        });
    //if (bandInsert) {
    /*var task = Task(
          int.tryParse(controllerForm['id'].text),
          controllerForm['name'].text,
          double.tryParse(controllerForm['price'].text),
          controllerForm['detailarticle'].text,
          int.tryParse(controllerForm['amount'].text));
      widget.callbackInsert(task);
      Navigator.pop(context);*/
    //}
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
                _boxTextField("Clave", controllerForm['id'],
                    TextInputType.number, widget.db),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controllerForm['name'],
                  onChanged: (String val) => {
                    if ((val.trim()).length <= 1)
                      {
                        _changedCircleAvatarName(val.trim()),
                      }
                  },
                  validator: (value) {
                    return (value.trim().isEmpty)
                        ? 'Rellena el campo'
                        : ((value.length > 29) ? "Maximo 29 caracteres" : null);
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
                _boxTextField("Precio", controllerForm['price'],
                    TextInputType.number, widget.db),
                SizedBox(
                  height: 10,
                ),
                _boxTextField(
                    "Detalle del producto",
                    controllerForm['detailarticle'],
                    TextInputType.text,
                    widget.db),
                SizedBox(
                  height: 10,
                ),
                _boxTextField("Cantidad", controllerForm['amount'],
                    TextInputType.number, widget.db),
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
