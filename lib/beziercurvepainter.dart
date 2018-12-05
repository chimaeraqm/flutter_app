import 'package:flutter/material.dart';
import 'package:flutter_app/PointF.dart';

class BezierCurvePainter/* extends CustomPainter*/
{
  double centerX = 0;
  double centerY = 0;

  //用于fragment初次建立时，centerX和centerY初始化后控制点的重置
  bool initCheck = false;
  /**
   * @param mPoints 保存控制点
   * @param drawPoints 所需绘制的点
   *
   */
  List<PointF> mPoints = new List();
  List<PointF> drawPoints = new List();

  //t:曲线绘制的控制节点
  double t = 0;

  //根据杨辉三角设置的曲线计算常数
  var constValue = new List();

  //bezier曲线的阶数
  var level;

  BezierCurvePainter(/*this.barHeight*/);


  void paint(Canvas canvas, Size size)
  {
    final paint = new Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;
    // drawRect：使用给定的Paint绘制一个矩形，是否填充或描边（或两者）是由Paint.style控制
    canvas.drawRect(
      // Rect.fromLTWH(double left, double top, double width, double height)：
      // 从左上角和上边缘构造一个矩形，并设置其宽度和高度
        new Rect.fromLTWH(0,0,0,0
//            size.width - barWidth/2.0,
//            size.height - barHeight,
//            barWidth,
//            barHeight*
        ),
        paint
    );
  }

//  @override
//  bool shouldRepaint(BezierCurvePainter oldDelegate) => barHeight != oldDelegate.barHeight;
}