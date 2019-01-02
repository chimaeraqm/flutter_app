import 'package:flutter/material.dart';

class TestMainPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Column(
        children: <Widget>[
          new MyAppBar(
            title: new Text(
                'instance title',
            style: Theme.of(context).primaryTextTheme.title),
          ),
          new MyNewButton(),
        ],
      ),
    );
  }
}

class MyAppBar extends StatelessWidget
{
  final Widget title;
  MyAppBar({
    this.title
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 56.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: new BoxDecoration(color: Colors.blue[500]),
      child: new Row(
        children: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              tooltip: 'navigation menu',
              onPressed: null
          ),
          new Expanded(
              child: title
          ),
          new IconButton(
              icon: new Icon(Icons.search),
              tooltip: 'searching',
              onPressed: null
          ),
        ],
      ),
    );
  }
}

class MyNewButton extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap:(){
        print('This button is monitored');
      },
      child: new Container(
        height: 36.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: new Center(
          child: new Text('click to listen temperary'),
        ),
      ),
    );
  }
}