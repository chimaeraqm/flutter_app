import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class BezierCurveView extends CustomPainter
{
  Paint mGridPaint;
  Paint mCurvePaint;
  BuildContext context;
  double _R;

  BezierCurveView(this.context,double r)
  {
    mGridPaint = new Paint();
    mGridPaint.style = PaintingStyle.stroke;
    mGridPaint.color = Color(0x60707070);
    mGridPaint.isAntiAlias = true;

    mCurvePaint = new Paint();
    mCurvePaint.style = PaintingStyle.fill;
    mCurvePaint.color = Colors.deepOrange;
    mCurvePaint.isAntiAlias = true;

    _R = r;
  }

  @override
  void paint(Canvas canvas, Size size)
  {
    var winSize = MediaQuery.of(context).size;
    canvas.drawPath(gridPath(20,winSize), mGridPaint);

    canvas.translate(100, 160);
    canvas.save();
    canvas.drawPath(starPath(5, _R, _R/2), mCurvePaint);
    canvas.restore();
  }

  Path starPath(int num,double R,double r)
  {
    Path path = new Path();
    double perDeg = 360 / num; //尖角的度数
    double degA = perDeg / 2 / 2;
    double degB = 360 / (num - 1) / 2 - degA / 2 + degA;

    path.moveTo(cos(_rad(degA)) * R, (-sin(_rad(degA)) * R));
    for (int i = 0; i < num; i++) {
      path.lineTo(
          cos(_rad(degA + perDeg * i)) * R, -sin(_rad(degA + perDeg * i)) * R);
      path.lineTo(
          cos(_rad(degB + perDeg * i)) * r, -sin(_rad(degB + perDeg * i)) * r);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Path gridPath(int step, Size winSize)
  {
    Path path = new Path();
    for (int i = 0; i < winSize.height / step + 1; i++)
    {
      path.moveTo(0, step * i.toDouble());
      path.lineTo(winSize.width, step * i.toDouble());
    }

    for (int i = 0; i < winSize.width / step + 1; i++) {
      path.moveTo(step * i.toDouble(), 0);
      path.lineTo(step * i.toDouble(), winSize.height);
    }
    return path;
  }

  double _rad(double deg)
  {
    return deg * pi / 180;
  }
}