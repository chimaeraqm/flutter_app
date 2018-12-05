import 'package:flutter/material.dart';
import 'package:flutter_app/homepage.dart';

void main()
{
  runApp(
      new MaterialApp(
        home: new HomePage(),
      )
  );
}

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: HomePage(),
    );
  }
}
