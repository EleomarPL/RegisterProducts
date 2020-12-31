import 'package:flutter/material.dart';
import '../../DatabaseOperation/Product.dart';
import '../../DatabaseOperation/DatabaseData.dart';

// ignore: must_be_immutable
class FormData extends StatefulWidget {
  Map<String, dynamic> dataArticle;
  DatabaseData db;
  Function callback;

  FormData({Key key, this.db, this.callback}) : super(key: key);

  FormData.update({Key key, this.dataArticle, this.db, this.callback})
      : super(key: key);

  @override
  _FormDatasState createState() => _FormDatasState();
}

class _FormDatasState extends State<FormData> {
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
    if (widget.dataArticle != null) {
      titleAvatar =
          ("${widget.dataArticle['name'][0]}".toString()).toUpperCase();
      controllerForm.forEach((key, value) {
        controllerForm[key].text = widget.dataArticle[key].toString();
      });
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
  }

  Widget _boxTextField(String placeholder, TextEditingController controllerText,
          TextInputType typeData, int maxlines) =>
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
                      : ((valueData == null)
                          ? "Digite un numero entero"
                          : null);
                  break;
                case 'Precio':
                  var valueData = double.tryParse(value);
                  return (value.length > 18)
                      ? "Maximo 17 caracteres"
                      : ((valueData == null)
                          ? "Digite un numero decimal"
                          : null);
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
        enabled: (placeholder == 'Clave')
            ? ((widget.dataArticle != null) ? false : true)
            : true,
      );

  void _changedCircleAvatarName(String val) {
    setState(() {
      titleAvatar = (val != "") ? val[0].toUpperCase() : "";
    });
  }

  void _operationDB(BuildContext context) {
    widget.callback(Product(
        id: int.tryParse((controllerForm['id'].text).trim()),
        name: (controllerForm['name'].text).trim(),
        price: double.tryParse(controllerForm['price'].text),
        detail: controllerForm['detailarticle'].text,
        amount: int.tryParse(controllerForm['amount'].text)));
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.purple[900],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    maxRadius: 50.0,
                    child: Text(
                      titleAvatar,
                      style: TextStyle(fontSize: 40, color: Colors.black),
                    ),
                  ),
                ),
                _boxTextField(
                    "Clave", controllerForm['id'], TextInputType.number, 1),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controllerForm['name'],
                  onChanged: (String val) {
                    if ((val.trim()).length <= 1) {
                      _changedCircleAvatarName(val.trim());
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
                _boxTextField(
                    "Precio", controllerForm['price'], TextInputType.number, 1),
                SizedBox(
                  height: 10,
                ),
                _boxTextField("Detalle del producto",
                    controllerForm['detailarticle'], TextInputType.text, 5),
                SizedBox(
                  height: 10,
                ),
                _boxTextField("Cantidad", controllerForm['amount'],
                    TextInputType.number, 1),
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
                    (widget.dataArticle != null) ? 'Actualizar' : 'Registrar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _operationDB(context);
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
                  onPressed: () => {
                    Navigator.of(context).pop(this),
                  },
                ),
              ],
            )),
        //)
      ),
    );
  }
}
