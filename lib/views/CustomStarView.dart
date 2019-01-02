import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class CustomStarView extends CustomPainter
{
  Paint mGridPaint;
  Paint mStarPaint;
  BuildContext context;
  double _R;
  int _Angles;
  Color _Color;

  CustomStarView(this.context,int angles, double r,Color color)
  {
    mGridPaint = new Paint();
    mGridPaint.style = PaintingStyle.stroke;
    mGridPaint.color = Color(0x60707070);
    mGridPaint.isAntiAlias = true;

    mStarPaint = new Paint();
    mStarPaint.style = PaintingStyle.fill;
    mStarPaint.color = color;
    mStarPaint.isAntiAlias = true;

    _R = r;
    _Angles = angles;
    _Color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var winSize = MediaQuery.of(context).size;
    canvas.drawPath(gridPath(20,winSize), mGridPaint);

    canvas.translate(100, 160);
    canvas.save();
    canvas.drawPath(starPath(_Angles, _R, _R/2), mStarPaint);
    canvas.restore();
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

  double _rad(double deg)
  {
    return deg * pi / 180;
  }

  Path regularStarPath(int num,double R)
  {
    double degA, degB;
    if (num % 2 == 1) {
      //奇数和偶数角区别对待
      degA = 360 / num / 2 / 2;
      degB = 180 - degA - 360 / num / 2;
    }
    else {
      degA = 360 / num / 2;
      degB = 180 - degA - 360 / num / 2;
    }
    double r = R * sin(_rad(degA)) / sin(_rad(degB));
    return starPath(num, R, r);
  }

  Path regularPolygonPath(int num, double R)
  {
    double r = R * cos(_rad(360 / num / 2));
    return starPath(num, R, r);
  }
}