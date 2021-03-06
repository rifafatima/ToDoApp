import 'package:flutter/material.dart';
import 'package:to_do_app/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do App',
      theme: ThemeData(
        primaryColor: Colors.blueGrey[50],
        accentColor: Colors.grey,
      ),
      home: Home(),
    );
  }
}
