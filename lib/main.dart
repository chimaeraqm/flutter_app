import 'package:flutter/material.dart';
import 'package:flutter_app/homepage.dart';
import 'package:flutter_app/TestMainPage.dart';

void main()
{
  runApp(
      new MaterialApp(
        title: 'pick curves',
        home: new TestMainPage(),
      )
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: HomePage(),
    );
  }
}


