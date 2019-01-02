import 'package:flutter/material.dart';
import 'package:flutter_app/objs/ball.dart';

class RunBallView extends CustomPainter
{
  Paint mPaint;
  BuildContext context;
  Ball _ball;
  Rect _limit;

  RunBallView(this.context, Ball ball, Rect limit) {
    mPaint = new Paint();
    _ball = ball;
    _limit = limit;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var winSize = MediaQuery.of(context).size;
    canvas.translate(160, 320);
    mPaint.color = Color.fromARGB(148, 198, 246, 248);
    canvas.drawRect(_limit, mPaint);

    canvas.save();
    drawBall(canvas, _ball);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
  //绘制小球
  void drawBall(Canvas canvas, Ball ball) {
    mPaint.color = ball.color;
    canvas.drawCircle(Offset(ball.x, ball.y), ball.r, mPaint);
  }
}