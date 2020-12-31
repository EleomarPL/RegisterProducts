import 'package:flutter/material.dart';
import 'Form/FormData.dart';
import '../ReusableComponents/TitleWindows.dart';

import '../DatabaseOperation/DatabaseData.dart';

class UpdateProduct extends StatefulWidget {
  final Map<String, dynamic> dataMainPage;
  final DatabaseData db;
  final Function callbackUpdate;
  UpdateProduct({
    Key key,
    this.dataMainPage,
    this.db,
    this.callbackUpdate,
  }) : super(key: key);

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  @override
  Widget build(BuildContext context) {
    return TitleWindow(
      title: 'Actualizar producto',
      body: FormData.update(
        db: widget.db,
        callback: widget.callbackUpdate,
        dataArticle: widget.dataMainPage,
      ),
    );
  }
}
