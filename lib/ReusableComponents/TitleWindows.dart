import 'package:flutter/material.dart';

class TitleWindow extends StatefulWidget {
  final Widget body;
  final String title;
  TitleWindow({Key key, this.body, this.title}) : super(key: key);

  @override
  _TitleWindowState createState() => _TitleWindowState();
}

class _TitleWindowState extends State<TitleWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.title),
          backgroundColor: Colors.purple,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              children: [widget.body]),
        ));
  }
}
