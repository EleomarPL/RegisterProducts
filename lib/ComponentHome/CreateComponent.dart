import 'package:flutter/material.dart';
import '../DatabaseOperation/databaseData.dart';
import '../updateProduct/updateProduct.dart';

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
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: fontsize,
          fontWeight: fontWeight,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
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
                      "¿Esta seguro que desea eliminar este producto?",
                      textAlign: TextAlign.center,
                    )),
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
                      color: Colors.white,
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
                            dividerColumnText(),
                            _customText(" ${widget.dataComponent['name']}",
                                FontWeight.bold, 18),
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
