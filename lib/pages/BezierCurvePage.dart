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
  //if initStateCheck == true，a new drawing process can be started over, all init parts should be initialized again.
  bool initStateCheck = true;

  //Control Param : get rid of multi click in process of curve drawing
  //if multiClickCheck == true，a new drawing process can be started over.
  bool multiClickCheck = true;

  //Control Param : check if the position of mPoints maintained
  //if pntsPosChangedCheck == true，one or more points coordinates changed(but number of points stays the same).
  //if initStateCheck switches to true, pntsPosChangedCheck switches to true as well.
  bool pntsPosChangedCheck = true;

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
        multiClickCheck = true;
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
    if(initStateCheck == true){
      getInitPoints();
      getInitConstValue();
      getInitAdsColors();
      initStateCheck = false;
    }

    if(pntsPosChangedCheck == true){
      drawPoints.clear();
      drawPoints.add(mPoints[0]);
      pntsPosChangedCheck = false;
    }

    var appbar = AppBar(
      title: Text("Bezier Curve"),
      backgroundColor: Color(0xff1989F9),
    );

    var floatingBn = FloatingActionButton(
      onPressed: (){
        if(multiClickCheck == true){
          drawPoints.clear();
          controller.reset();
          controller.forward();
          multiClickCheck = false;
        }
      },
      tooltip: 'Drawing',
      backgroundColor: Color(0xff1989F9),
      child: Icon(Icons.airplanemode_active),
    );

    var body = CustomPaint(
      painter: BezierCurveViewNew(context,mPoints,drawPoints,constValue,adsLinePaintColors,adsPointPaintColors,_t),
    );

    var drawerHeader = DrawerHeader(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: new DecorationImage(
            image: new ExactAssetImage('images/drawerheader_w800.jpg'),
            fit: BoxFit.fill,)
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
//      padding: EdgeInsets.fromLTRB(double.infinity, double.infinity, 10.0, 10.0),
        alignment: Alignment.bottomLeft,
        child: new Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            'Choose Curve Type here.\nThen click SIMU.',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                fontSize: 20.0
            ),
          ),
        ),
      ),
    );

    drawItem(int level)
    {
      String title = 'BezierCurve('+level.toString()+')';
      String subtitle = 'Create Lv'+level.toString()+' Bezier Curve';
      return Container(
        //width: 160.0,
        child: new ListTile(
          title: new Text(title),
          subtitle: new Text(subtitle),
          trailing: new Icon(Icons.blur_off),
          onTap: (){
            _level = level;
            initStateCheck = true;
            pntsPosChangedCheck = true;
            Navigator.pop(context);
            setState(() {

            });
            //_pushCurvePagewithAnimation(title,subtitle);
//            _openNewPage();
          },
        ),
      );
    }

    var drawer = Drawer(
      child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            drawerHeader,
//          userHeader,
            drawItem(2),
            drawItem(3),
            drawItem(4),
            drawItem(5),
            drawItem(6),
            drawItem(7),
            drawItem(8),
            drawItem(9),
            drawItem(10),]
      ),
    );

    var mainScaffold = Scaffold(
      appBar: appbar,
      body: body,
      floatingActionButton: floatingBn,
      drawer: drawer,
    );

    var gestureDetector = GestureDetector(
      child: mainScaffold,
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
        pntsPosChangedCheck = true;
        setState(() {

        });
      },
      onPanCancel: (){
      },
      onPanUpdate: (pos){
        currentPos = pos.globalPosition;
        mPoints[pickTag] = PointF(x: currentPos.dx,y: currentPos.dy);
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
    adsLinePaintColors.clear();
    adsPointPaintColors.clear();
    for (int i = 0; i < _level - 1; i++){
      adsLinePaintColors.add(pickRandomColor());
      adsPointPaintColors.add(pickRandomColor());
    }
  }

  void getInitPoints()
  {
    //init mPoints
    mPoints.clear();
    var winSize = MediaQuery.of(context).size;
    //初始化各点位置
    double gap = (winSize.width-20) / _level;
    for (int i = 0; i <= _level; i++) {
      double xpos = 10+gap*i;
      double ypos = winSize.height/2;
      var point = PointF(x: xpos, y: ypos);
      mPoints.add(point);
    }
  }

  Color pickRandomColor()
  {
    Random random = new Random();
    int r = 30 + random.nextInt(200);
    int g = 30 + random.nextInt(200);
    int b = 30 + random.nextInt(200);
    return Color.fromARGB(60, r, g, b);
  }

  /**
   * 计算两点距离
   */
  double distanceBetween(double x1,double y1,double x2,double y2)
  {
    double dist = sqrt(pow((x2-x1),2)+pow((y2-y1),2));
    return dist;
  }

/**
 * 封装控件
 */

  defineBackground(Widget w,)
  {
    return Container(
        color: Colors.red,
        child: w
    );
  }
}
