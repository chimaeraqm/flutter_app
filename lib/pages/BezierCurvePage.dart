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
  double _t;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 10*1000),
        vsync: this);
    animation = Tween(
        begin: 0.0,
        end: 1.0).animate(controller)
    ..addListener((){
      setState(() {
        _t = animation.value;
      });
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
        painter: BezierCurveViewNew(context,_t,3),
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
