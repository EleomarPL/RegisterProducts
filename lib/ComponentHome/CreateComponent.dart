import 'package:flutter/material.dart';
import '../AddUpdate/UpdateProduct.dart';
import '../ReusableComponents/Transition.dart';
import '../DatabaseOperation/DatabaseData.dart';

class CreateComponent extends StatefulWidget {
  final Map<String, dynamic> dataComponent;
  final DatabaseData db;
  final Function callbackDelete;
  final Function callbackUpdate;
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
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: fontsize,
          fontWeight: fontWeight,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      );
  Widget _dividerColumnText() => Divider(
        color: Colors.blue[300],
        height: 10,
        thickness: 2,
      );
  _updateComponent(BuildContext context) {
    widget.callbackDelete(widget.dataComponent['id']);
    Navigator.pop(context);
  }

  _deleteProduct(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      "¿Esta seguro que desea eliminar este producto?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          color: Colors.purple[900],
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
                          color: Colors.purple[900],
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.purple[900],
            ),
            child: Column(children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
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
                            _dividerColumnText(),
                            _customText(" ${widget.dataComponent['name']}",
                                FontWeight.bold, 18),
                            _dividerColumnText(),
                            _customText(" \$${widget.dataComponent['price']}",
                                FontWeight.normal, 17),
                            _dividerColumnText(),
                            _customText(
                                " Detalle: ${widget.dataComponent['detailarticle']}",
                                FontWeight.normal,
                                17),
                            _dividerColumnText(),
                            _customText(
                                " Cantidad: ${widget.dataComponent['amount']}",
                                FontWeight.normal,
                                17),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
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
            Navigator.of(context).push(
              Transition.handleNavigationPressed(
                UpdateProduct(
                  dataMainPage: widget.dataComponent,
                  db: widget.db,
                  callbackUpdate: widget.callbackUpdate,
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
