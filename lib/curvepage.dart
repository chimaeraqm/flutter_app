import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math';

class CurvePage extends StatefulWidget
{
  final String title;
  final String subtitle;

  CurvePage({Key key,this.title,this.subtitle}):super(key: key);

  @override
  State createState() {
    return new _CurvePageState(title: title,subtitle: subtitle);
  }

}

class _CurvePageState extends State<CurvePage> with TickerProviderStateMixin
{
  final random = new Random();
  int dataSet = 50;
  AnimationController animationController;
  double startHeight;
  double currentHeight;
  double endHeight;

  final String title;
  final String subtitle;

  _CurvePageState({Key key,this.title,this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueGrey,
      ),
//      body: Text(subtitle),
      body: _buildBezierCurve(),
    );
  }

  Widget _buildBezierCurve()
  {
    Widget beziercurve = Center(
        child: new CustomPaint(
          size: Size(200.0, 200.0),
          //painter: new BezierCurvePainter(/*currentHeight*/),
        )
//      child: BezierCurveWidget(title,subtitle),
    );
    return beziercurve;
  }

  @override
  void initState() {
    super.initState();
    /*
    AnimationController({
      double value,
      Duration duration,
      String debugLabel,
      double lowerBound: 0.0,
      double upperBound: 1.0,
      TickerProvider vsync
    })
    创建动画控制器
     */
    animationController = new AnimationController(
      // 这个动画应该持续的时间长短
        duration: const Duration(milliseconds: 3000),
        vsync: this
    )
    /*
    void addListener(
      VoidCallback listener
    )
    每次动画值更改时调用监听器
    可以使用removeListener删除监听器
     */
      ..addListener((){
        setState((){
          /*
        double lerpDouble(
          num a,
          num b,
          double t
        )
        在两个数字之间进行线性内插
        return a + (b - a) * t;
         */
          currentHeight = lerpDouble(
              startHeight,
              endHeight,
              animationController.value
          );
        });
      });
    startHeight = 0.0;
    currentHeight = 0.0;
    endHeight = dataSet.toDouble();
    // 开始向前运行这个动画（朝向最后）
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

//  void changeData() {
//    setState(() {
//      startHeight = currentHeight;
//      dataSet = random.nextInt(100);
//      endHeight = dataSet.toDouble();
//      animationController.forward(from: 0.0);
//    });
//  }
}