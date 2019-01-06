import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/views/BezierCurveViewNew.dart';
import 'package:flutter_app/objs/PointF.dart';

class BezierCurvePage extends StatefulWidget
{

  @override
  State createState() {
    return new _BezierCurvePageState();
  }
}

class _BezierCurvePageState extends State<BezierCurvePage> with SingleTickerProviderStateMixin
{
  AnimationController controller;
  Animation<double> animation;
  var drawPoints = List<PointF>();
  var mPoints = List<PointF>();
  var constValue = [1, 2, 1];
  double _t = 0.0;
  int _level = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_level == 3) {
      constValue = [1, 3, 3, 1];
    }
    else if (_level == 4) {
      constValue = [1, 4, 6, 4, 1];
    }
    else if (_level == 5) {
      constValue = [1, 5, 10, 10, 5, 1];
    }
    else if (_level == 6) {
      constValue = [1, 6, 15, 20, 15, 6, 1];
    }
    else if (_level == 7) {
      constValue = [1, 7, 21, 35, 35, 21, 7, 1];
    }
    else if (_level == 8) {
      constValue = [1, 8, 28, 56, 70, 56, 28, 8, 1];
    }
    else if (_level == 9) {
      constValue = [1, 9, 36, 84, 126, 126, 84, 36, 9, 1];
    }
    else if (_level == 10) {
      constValue = [1, 10, 45, 120, 200, 252, 200, 120, 45, 10, 1];
    }

    controller = AnimationController(
        duration: const Duration(milliseconds: 100000),
        vsync: this);
    animation = Tween(
        begin: 0.0,
        end: 1.0).animate(controller)
    ..addListener((){
      setState(() {
        _t = animation.value;
        //get mPoints and drawPoints based on _time
        double finalX = 0;
        double finalY = 0;
        //level 临时计算bezier曲线的阶数
        for(int i=0;i < mPoints.length;i++)
        {
          PointF pointi = mPoints[i];
          double pointix = pointi.x;
          double pointiy = pointi.y;
          int param = constValue[i];
          double x = param * pointix * pow(1-_t,_level-i) * pow(_t,i);
          double y = param * pointiy * pow(1-_t,_level-i) * pow(_t,i);
          finalX += x;
          finalY += y;
        }
        var nextPoint = PointF(x:finalX,y:finalY);
        drawPoints.add(nextPoint);
      });
    })
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        controller.reset();
      }
      /*else if(status == AnimationStatus.dismissed){
        controller.forward();
      }*/
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Bezier curve (lv 2)"),
        backgroundColor: Color(0xff1989F9),
      ),
//      body: Text(subtitle),
      body: CustomPaint(
        painter: BezierCurveViewNew(context,mPoints,drawPoints,_level),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          controller.forward();
        },
        tooltip: 'Increment',
        backgroundColor: Color(0xff1989F9),
        child: Icon(Icons.airplanemode_active),),
    );
  }
}
