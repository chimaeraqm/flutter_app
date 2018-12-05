import 'package:flutter/material.dart';
//import 'package:sky_engine/ui/ui.dart';
import 'beziercurvepainter.dart';

class BezierCurveWidget extends StatelessWidget{

  final String mTitle;
  final String mSubtitle;

  BezierCurveWidget(this.mTitle,this.mSubtitle);

  @override
  Widget build(BuildContext context) {
    Widget bezierCurve = new CustomPaint(
      size: Size(200.0, 200.0),
//      painter: new BezierCurvePainter(),
    );
    return bezierCurve;
  }
}