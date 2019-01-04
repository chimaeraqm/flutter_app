import 'package:flutter/material.dart';
import 'package:flutter_app/pages/BezierCurvePage.dart';

void main()
{
  runApp(
      new MaterialApp(
        title: 'pick curves',
        home: new MyApp(),
      )
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: HomePage(),
      home: BezierCurvePage(),
    );
  }
}


