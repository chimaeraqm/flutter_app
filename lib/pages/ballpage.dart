import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/objs/ball.dart';
import 'package:flutter_app/views/BallView.dart';

class BallPage extends StatefulWidget
{

  @override
  State createState() {
    return new _BallPageState();
  }
}

class _BallPageState extends State<BallPage> with SingleTickerProviderStateMixin
{
  AnimationController controller;
  var _balls = List<Ball>();//将_ball换成集合
//  Ball _ball;
  var _limit = Rect.fromLTRB(-140, -100, 140, 100);//矩形边界

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var ball = Ball(x: 0, y: 0, color: Colors.blue, r: 40, aX: 0, aY: 0.1, vX: 2, vY: -2);
    _balls.add(ball);
    controller = AnimationController(
        duration: const Duration(milliseconds: 200000),
        vsync: this);
    controller.addListener((){
      updateBall();
      setState(() {

      });
    });
    
    controller.addStatusListener((status){
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Ball Page"),
      ),
      body: CustomPaint(
        painter: RunBallView(context, _balls, _limit),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            controller.forward();
          },
        tooltip: 'Increment',
        child: Icon(Icons.ac_unit),
      ),
    );
  }

  //更新小球位置
  void updateBall()
  {
    for(int i=0;i<_balls.length;i++) {
      var ball = _balls[i];
      if(ball.r < 0.3){
        _balls.removeAt(i);
      }
      //运动学公式
      ball.x += ball.vX;
      ball.y += ball.vY;
      ball.vX += ball.aX;
      ball.vY += ball.aY;
      //限定下边界
      if (ball.y > _limit.bottom - ball.r) {
        var newBall = Ball.fromBall(ball);
        newBall.r = newBall.r / 2;
        newBall.vX = -newBall.vX;
        newBall.vY = -newBall.vY;
        _balls.add(newBall);
        ball.r = ball.r / 2;

        ball.y = _limit.bottom;
        ball.vY = -ball.vY;
        ball.color = pickRandomColor(); //碰撞后随机色
      }
      //限定上边界
      if (ball.y < _limit.top + ball.r) {
        ball.y = _limit.top;
        ball.vY = -ball.vY;
        ball.color = pickRandomColor(); //碰撞后随机色
      }

      //限定左边界
      if (ball.x < _limit.left - ball.r) {
        ball.x = _limit.left;
        ball.vX = -ball.vX;
        ball.color = pickRandomColor(); //碰撞后随机色
      }

      //限定右边界
      if (ball.x > _limit.right + ball.r) {
        var newBall = Ball.fromBall(ball);
        newBall.r = newBall.r / 2;
        newBall.vX = -newBall.vX;
        newBall.vY = -newBall.vY;
        _balls.add(newBall);
        ball.r = ball.r / 2;

        ball.x = _limit.right;
        ball.vX = -ball.vX;
        ball.color = pickRandomColor(); //碰撞后随机色
      }
    }
  }

  Color pickRandomColor()
  {
    Random random = new Random();
    int r = 30 + random.nextInt(200);
    int g = 30 + random.nextInt(200);
    int b = 30 + random.nextInt(200);
    return Color.fromARGB(255, r, g, b);
  }
}