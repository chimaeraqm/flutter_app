import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/views/BezierCurveViewNew.dart';
import 'package:flutter_app/objs/PointF.dart';

class BezierCurvePage extends StatefulWidget
{

  @override
  State createState() {
    return new _BezierCurvePageState();
  }
}

class _BezierCurvePageState extends State<BezierCurvePage> with SingleTickerProviderStateMixin
{
  AnimationController controller;
  Animation<double> animation;
  var drawPoints = List<PointF>();
  var mPoints = List<PointF>();
  var constValue = [1, 2, 1];
  var adsLinePaintColors = List<Color>();
  var adsPointPaintColors = List<Color>();
  int _level = 3;
  double _t;

  /**
   * @ param pickTag 用于标记将要移动点的序号
   * @ param currentPos 记录选中点的偏移坐标
   */
  int pickTag = -1;
  Offset currentPos;

  //Control Param : check control points initialization status, if initStateCheck == true, initialize mPoints and drawPoints as well
  //when get to point AnimationStatus.completed, initStateCheck = true;
  bool initStateCheck = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //init constValue based on number of level
    controller = AnimationController(
        duration: const Duration(milliseconds: 5000),
        vsync: this);
    animation = Tween(
        begin: 0.0,
        end: 1.0).animate(controller)
    ..addListener((){
      setState(() {
        _t = animation.value;
        updateDrawPoints();
      });
    })
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        initStateCheck = true;
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
  Widget build(BuildContext context) {
    // TODO: implement build
    getInitConstValue();
    getInitAdsColors();
    if(initStateCheck == true){

    }
    getInitPoints();

    var appbar = AppBar(
      title: Text("Bezier curve (lv 2)"),
      backgroundColor: Color(0xff1989F9),
    );

    var floatingBn = FloatingActionButton(
      onPressed: (){
        if(initStateCheck == true){
          controller.reset();
          mPoints.clear();
          drawPoints.clear();
          adsLinePaintColors.clear();
          adsPointPaintColors.clear();
          getInitPoints();
          controller.forward();
          initStateCheck = false;
        }
      },
      tooltip: 'Increment',
      backgroundColor: Color(0xff1989F9),
      child: Icon(Icons.airplanemode_active),
    );

    var body = CustomPaint(
      painter: BezierCurveViewNew(context,mPoints,drawPoints,constValue,adsLinePaintColors,adsPointPaintColors,_t),
    );

    var mainScaffold = Scaffold(
      appBar: appbar,
      body: body,
      floatingActionButton: floatingBn,
    );

    var gestureDetector = GestureDetector(
      child: mainScaffold,
      onTap: (){
        print("OnTap");
        setState(() {

        });
      },
      onTapDown: (pos){
        print("onTapDown" + pos.globalPosition.toString());
        setState(() {

        });
      },
      onTapUp: (pos){
        mPoints[pickTag] = PointF(x: currentPos.dx,y: currentPos.dy);
        setState(() {

        });
      },
      onTapCancel: (){
        print("onTapCancel");
        setState(() {

        });
      },
      onPanStart: (pos){
        print("onPanStart" + pos.globalPosition.toString());
        setState(() {

        });
      },
      onPanDown: (pos){
        /**
         * @param distance 用于记录鼠标点击点和各控制点的距离，距离最近的点即为将要移动的点
         */

        double lastPointX = pos.globalPosition.dx;
        double lastPointY = pos.globalPosition.dy;
        double distance = 0;
        for(int i=0;i<mPoints.length;i++)
        {
          PointF pointF = mPoints[i];
          if(i == 0)
          {
            distance = distanceBetween(pointF.x,pointF.y,lastPointX,lastPointY);
            pickTag = 0;
          }
          else
          {
            double newdist = distanceBetween(pointF.x,pointF.y,lastPointX,lastPointY);
            if(newdist < distance)
            {
              distance = newdist;
              pickTag = i;
            }
          }
        }
        setState(() {

        });
      },
      onPanEnd: (pos){
        mPoints[pickTag] = PointF(x: currentPos.dx,y: currentPos.dy);
        setState(() {

        });
      },
      onPanCancel: (){
      },
      onPanUpdate: (pos){
        print("onPanUpdate" + pos.globalPosition.toString());
        currentPos = pos.globalPosition;
        setState(() {

        });
      },
    );

    return gestureDetector;
  }

  void updateDrawPoints()
  {
    //get mPoints and drawPoints based on _time
    double finalX = 0;
    double finalY = 0;
    //level 临时计算bezier曲线的阶数
    for(int i=0;i < mPoints.length;i++)
    {
      PointF pointi = mPoints[i];
      double pointix = pointi.x;
      double pointiy = pointi.y;
      int param = constValue[i];
      double x = param * pointix * pow(1-_t,_level-i) * pow(_t,i);
      double y = param * pointiy * pow(1-_t,_level-i) * pow(_t,i);
      finalX += x;
      finalY += y;
    }
    var nextPoint = PointF(x:finalX,y:finalY);
    drawPoints.add(nextPoint);
  }

  void getInitConstValue()
  {
    if (_level == 3) {
      constValue = [1, 3, 3, 1];
    }
    else if (_level == 4) {
      constValue = [1, 4, 6, 4, 1];
    }
    else if (_level == 5) {
      constValue = [1, 5, 10, 10, 5, 1];
    }
    else if (_level == 6) {
      constValue = [1, 6, 15, 20, 15, 6, 1];
    }
    else if (_level == 7) {
      constValue = [1, 7, 21, 35, 35, 21, 7, 1];
    }
    else if (_level == 8) {
      constValue = [1, 8, 28, 56, 70, 56, 28, 8, 1];
    }
    else if (_level == 9) {
      constValue = [1, 9, 36, 84, 126, 126, 84, 36, 9, 1];
    }
    else if (_level == 10) {
      constValue = [1, 10, 45, 120, 200, 252, 200, 120, 45, 10, 1];
    }
  }

  void getInitAdsColors()
  {
    for (int i = 0; i < _level - 1; i++){
      adsLinePaintColors.add(pickRandomColor());
      adsPointPaintColors.add(pickRandomColor());
    }
  }

  void getInitPoints()
  {
    //init mPoints
    mPoints.clear();
    drawPoints.clear();
    var winSize = MediaQuery.of(context).size;
    //初始化各点位置
    double gap = winSize.width / _level;
    mPoints.add(PointF(x: 20, y: 20));
    mPoints.add(PointF(x: gap + 10,y: 200));
    mPoints.add(PointF(x: gap*2 - 10,y: 200));
    mPoints.add(PointF(x: gap*3 - 20,y: 20));

/*
    for (int i = 0; i <= _level; i++) {
      double xpos = gap * i + 20;
      double ypos = 20;
      if(i == 1 || i == 2){
        ypos = 200;
      }
      var point = PointF(x: xpos, y: ypos);
      mPoints.add(point);
    }
*/
    drawPoints.add(mPoints[0]);
  }

  Color pickRandomColor()
  {
    Random random = new Random();
    int r = 30 + random.nextInt(200);
    int g = 30 + random.nextInt(200);
    int b = 30 + random.nextInt(200);
    return Color.fromARGB(255, r, g, b);
  }

  /**
   * 计算两点距离
   */
  double distanceBetween(double x1,double y1,double x2,double y2)
  {
    double dist = sqrt(pow((x2-x1),2)+pow((y2-y1),2));
    return dist;
  }
}
