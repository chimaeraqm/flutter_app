import 'package:flutter/material.dart';
import 'package:flutter_app/objs/ball.dart';

class RunBallView extends CustomPainter
{
  Paint mPaint;
  BuildContext context;
  var _balls = List<Ball>();//将_ball换成集合
//  Ball _ball;
  Rect _limit;

  RunBallView(this.context, List<Ball> balls, Rect limit) {
    mPaint = new Paint();
    _balls = balls;
    _limit = limit;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var winSize = MediaQuery.of(context).size;
    canvas.translate(160, 320);
    mPaint.color = Color.fromARGB(148, 198, 246, 248);
    canvas.drawRect(_limit, mPaint);

    canvas.save();
    drawBall(canvas, _balls);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
  //绘制小球
  void drawBall(Canvas canvas, List<Ball> balls) {
    _balls.forEach((ball){
      mPaint.color = ball.color;
      canvas.drawCircle(Offset(ball.x, ball.y), ball.r, mPaint);
    });
  }
}