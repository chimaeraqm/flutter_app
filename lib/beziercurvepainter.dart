import 'package:flutter/material.dart';

class BezierCurvePainter extends CustomPainter{

  static const barWidth = 10.0;
  final double barHeight;
  BezierCurvePainter(this.barHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;
    // drawRect：使用给定的Paint绘制一个矩形，是否填充或描边（或两者）是由Paint.style控制
    canvas.drawRect(
      // Rect.fromLTWH(double left, double top, double width, double height)：
      // 从左上角和上边缘构造一个矩形，并设置其宽度和高度
        new Rect.fromLTWH(
            size.width - barWidth/2.0,
            size.height - barHeight,
            barWidth,
            barHeight
        ),
        paint
    );
  }

  @override
  bool shouldRepaint(BezierCurvePainter oldDelegate) => barHeight != oldDelegate.barHeight;
}