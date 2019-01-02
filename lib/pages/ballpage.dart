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
  Ball _ball;
  var _limit = Rect.fromLTRB(-140, -100, 140, 100);//矩形边界

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ball = Ball(x: 0, y: 0, color: Colors.blue, r: 10, aX: 0, aY: 0.1, vX: 2, vY: -2);
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
        painter: RunBallView(context, _ball, _limit),
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
  void updateBall() {
    //运动学公式
    _ball.x += _ball.vX;
    _ball.y += _ball.vY;
    _ball.vX += _ball.aX;
    _ball.vY += _ball.aY;
    //限定下边界
    if (_ball.y > _limit.bottom - _ball.r) {
      _ball.y = _limit.bottom - _ball.r;
      _ball.vY = -_ball.vY;
      _ball.color = Colors.deepOrange;//碰撞后随机色
    }
    //限定上边界
    if (_ball.y < _limit.top + _ball.r) {
      _ball.y = _limit.top + _ball.r;
      _ball.vY = -_ball.vY;
      _ball.color = Colors.blueAccent;//碰撞后随机色
    }

    //限定左边界
    if (_ball.x < _limit.left + _ball.r) {
      _ball.x = _limit.left + _ball.r;
      _ball.vX = -_ball.vX;
      _ball.color = Colors.green;//碰撞后随机色
    }

    //限定右边界
    if (_ball.x > _limit.right - _ball.r) {
      _ball.x = _limit.right - _ball.r;
      _ball.vX= -_ball.vX;
      _ball.color = Colors.yellow;//碰撞后随机色
    }
  }
}