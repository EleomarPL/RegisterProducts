import 'package:flutter/material.dart';
import '../DatabaseOperation/Task.dart';
import '../DatabaseOperation/databaseData.dart';

// ignore: must_be_immutable
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
        TextInputType typeData, bool isEnabled, int maxlines) =>
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
      minLines: 1,
      maxLines: maxlines,
      decoration: InputDecoration(labelText: placeholder),
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
    titleAvatar = ("${widget.dataArticle['name'][0]}".toString()).toUpperCase();
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
      titleAvatar = (val != "") ? val[0].toUpperCase() : "";
    });
  }

  void _returnMainPage(BuildContext context) {
    Navigator.of(context).pop(this);
  }

  void _updateProduct(BuildContext context) {
    var taskUpdate = Task(
        widget.dataArticle['id'],
        (controllerForm['name'].text).trim(),
        double.tryParse(controllerForm['price'].text),
        controllerForm['detailarticle'].text,
        int.tryParse(controllerForm['amount'].text));
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
                    color: Colors.purple[900],
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: 50.0,
                      child: Text(
                        titleAvatar,
                        style: TextStyle(fontSize: 40, color: Colors.black),
                      ),
                    )),
                _boxTextField("Clave", controllerForm['id'],
                    TextInputType.number, false, 1),
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
                  decoration: const InputDecoration(
                    labelText: "Nombre",
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 10,
                ),
                _boxTextField("Precio", controllerForm['price'],
                    TextInputType.number, true, 1),
                SizedBox(
                  height: 10,
                ),
                _boxTextField(
                    "Detalle del producto",
                    controllerForm['detailarticle'],
                    TextInputType.text,
                    true,
                    5),
                SizedBox(
                  height: 10,
                ),
                _boxTextField("Cantidad", controllerForm['amount'],
                    TextInputType.number, true, 1),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  color: Colors.purple[700],
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
                        _updateProduct(context),
                      }
                  },
                ),
                RaisedButton(
                  color: Colors.pink,
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
