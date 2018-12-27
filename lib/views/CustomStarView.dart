import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class CustomStarView extends CustomPainter
{
  Paint mGridPaint;
  Paint mStarPaint;
  BuildContext context;

  CustomStarView(this.context,Color color)
  {
    mGridPaint = new Paint();
    mGridPaint.style = PaintingStyle.stroke;
    mGridPaint.color = Color(0x60707070);
    mGridPaint.isAntiAlias = true;

    mStarPaint = new Paint();
    mStarPaint.style = PaintingStyle.fill;
    mStarPaint.color = color;
    mStarPaint.isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var winSize = MediaQuery.of(context).size;
//    canvas.save();
    canvas.drawPath(gridPath(20,winSize), mGridPaint);
//    canvas.restore();

    canvas.translate(0, 160);
    canvas.save();
    for (int i = 5; i < 10; i++) {
      canvas.translate(64, 0);
      canvas.drawPath(starPath(i, 30, 15), mStarPaint);
    }
    canvas.restore();

    canvas.translate(0, 70);
    canvas.save();//绘制正n角星
    for (int i = 5; i < 10; i++) {
      canvas.translate(64, 0);
      canvas.drawPath(regularStarPath(i, 30), mStarPaint);
    }
    canvas.restore();

    canvas.translate(0, 70);
    canvas.save();//绘制正n边形
    for (int i = 5; i < 10; i++) {
      canvas.translate(64, 0);
      canvas.drawPath(regularPolygonPath(i, 30), mStarPaint);
    }
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