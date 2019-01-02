import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math';
import 'package:flutter_app/views/BezierCurveView.dart';
import 'package:flutter_app/views/CustomStarView.dart';

class CurvePage extends StatefulWidget
{

  @override
  State createState() {
    return new _CurvePageState();
  }

}

class _CurvePageState extends State<CurvePage> with SingleTickerProviderStateMixin
{
  AnimationController controller;
  Animation<double> animation;
  Animation<int> numAnima;
  Animation<Color> colorAnima;
  double _R = 25;
  int _Angles = 5;
  Color _Color = new Color(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration:const Duration(milliseconds: 2000),
        vsync: this);
    animation = Tween(
        begin: 25.0,
        end: 150.0).animate(
        CurveTween(curve: Cubic(0.96, 0.13, 0.1, 1.2)).animate(controller))
    ..addListener((){
      setState(() {
        _R = animation.value;
      });
    })
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        controller.reverse();
      }
      else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
    });

    numAnima = IntTween(
      begin: 5,
      end:220
    ).animate(controller)
    ..addListener((){
      setState(() {
        _Angles = numAnima.value;
      });
    })
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        controller.reverse();
      }
      else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
    });

    colorAnima = ColorTween(
      begin: Colors.yellow,
      end: Colors.blueAccent
    ).animate(controller)
    ..addListener((){
      setState(() {
        _Color = colorAnima.value;
      });
    })
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        controller.reverse();
      }
      else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
    });
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bezier curve (lv 1)"),
        backgroundColor: Color(0xfff5484a),
      ),
//      body: Text(subtitle),
      body: CustomPaint(
          painter: CustomStarView(context,_Angles,_R,_Color),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            controller.forward();
          },
          tooltip: 'Increment',
          child: Icon(Icons.access_alarm),),
    );
  }
}