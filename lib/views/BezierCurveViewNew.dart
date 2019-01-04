import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/objs/PointF.dart';

class BezierCurveViewNew extends CustomPainter
{
  BuildContext mContext;
  double centerX = 0;
  double centerY = 0;
  //用于fragment初次建立时，centerX和centerY初始化后控制点的重置
  bool initCheck = false;
  /**
   * @param mPoints 保存控制点
   * @param drawPoints 所需绘制的点
   *
   */
  var mPoints;
  var drawPoints;

  //t:曲线绘制的控制节点
  double t = 0;

  //根据杨辉三角设置的曲线计算常数
  var constValue;

  //bezier曲线的阶数
  int _level;

  /**
   * @ param pickTag 用于标记将要移动点的序号
   */
  int pickTag = -1;

  /**
   * 界面上绘制的图形包括
   * 1 控制点连线 mControlLinePaint
   * 2 控制点 mControlPointPaint
   * 3 bezier曲线 mBezierPaint
   * 4 bezier曲线端点 mBezierPaint
   * 4 文字 mTextPaint
   * 5 辅助线
   * 6 辅助线端点（与控制点连线的交点）
   */
  //绘制各线的paint和path
  Paint mControlLinePaint;
  Paint mControlPointPaint;

  Paint mBezierPaint;
  Paint mBezierPointPaint;

  Paint mTextPaint;
  var adsLinePaints;
  var adsPointPaints;

  Path mControlPath = new Path();
  Path mBezierPath;
  Path mAdsLinePath;

  Paint mGridPaint;
  double mGridGap_Width;
  double mGridGap_Height;

  double _time;

  BezierCurveViewNew(this.mContext,double time,int level)
  {
    adsLinePaints = List<Paint>();
    adsPointPaints = List<Paint>();
    mPoints = List<PointF>();
    drawPoints = List<PointF>();
    _time = time;
    _level = level;
    initView();
  }

  //equals onDraw in Android
  @override
  void paint(Canvas canvas, Size size)
  {
    //get mPoints and drawPoints based on _time
    double finalX = 0;
    double finalY = 0;
    //level 临时计算bezier曲线的阶数
    for(int i=0;i<mPoints.length;i++)
    {
      PointF pointi = mPoints[i];
      double pointix = pointi.x;
      double pointiy = pointi.y;
      int param = constValue[i];
      double x = param * pointix * pow(1-t,_level-i) * pow(t,i);
      double y = param * pointiy * pow(1-t,_level-i) * pow(t,i);
      finalX += x;
      finalY += y;
    }
    var nextPoint = PointF(x:finalX,y:finalY);
    drawPoints.add(nextPoint);

    //get canvas size
    var winSize = MediaQuery.of(mContext).size;
    double height = winSize.height;
    double width = winSize.width;
    mGridGap_Width = width/10.0;
    mGridGap_Height = height/10.0;
    double gridWidth_a = mGridGap_Width;
    double gridHeight_a = mGridGap_Height;
    Path gridPath = new Path();
    for(int i=0;i<9;i++)
    {
      //用纵横虚线划分绘图区域
      gridPath.moveTo(gridWidth_a,0);
      gridPath.lineTo(gridWidth_a,height);
      canvas.drawPath(gridPath,mGridPaint);
      gridPath.reset();

      gridPath.moveTo(0,gridHeight_a);
      gridPath.lineTo(width,gridHeight_a);
      canvas.drawPath(gridPath,mGridPaint);
      gridPath.reset();

      gridWidth_a += mGridGap_Width;
      gridHeight_a += mGridGap_Height;
    }
    //mControlPointPaint绘制控制点，mTextPaint绘制控制点文字
    for(int i=0;i<mPoints.length;i++)
    {
      PointF pointi = mPoints[i];
      canvas.drawCircle(Offset(pointi.x, pointi.y),1,mControlPointPaint);
      int pos = mPoints.indexOf(pointi);
      /*String pointText = (Locale.US,"P%d(%.2f,%.2f)",pos,pointi.x,pointi.y);
      //获取String边界，校正String显示位置
      Rect textRect = new Rect();
      mTextPaint.getTextBounds(pointText,0,pointText.length(),textRect);
      if((pointi.x + textRect.width()) > getWidth())
      {
        float startX =  getWidth() - textRect.width();
        canvas.drawText(pointText,startX,pointi.y,mTextPaint);
      }
      else
      {
        canvas.save();
        canvas.rotate(-45,pointi.x,pointi.y);
        canvas.drawText(pointText,pointi.x,pointi.y,mTextPaint);
        canvas.restore();
      }*/
    }

    //mControlLinePaint沿mControlPath绘制辅助线
    mControlPath.reset();
    PointF pointHead = mPoints[0];
    mControlPath.moveTo(pointHead.x,pointHead.y);
    var adsPoints = List<PointF>();
    for(int i=0;i<mPoints.length;i++)
    {
      PointF pointi = mPoints[i];
      mControlPath.lineTo(pointi.x,pointi.y);
      adsPoints.add(pointi);
    }
    canvas.drawPath(mControlPath,mControlLinePaint);

    //adsLinePaints绘制辅助线，adsPointPaints绘制辅助线端点
    var backupAdsPoints = List<PointF>();
    for(int i=0;i<_level-1;i++)
    {
      Paint adsPointPaint1 = adsPointPaints[i];
      Paint adsLinePaint1 = adsLinePaints[i];
      mAdsLinePath.reset();
      for(int m=1;m < adsPoints.length;m++)
      {
        PointF point0 = adsPoints[m-1];
        PointF pointi = adsPoints[m];
        PointF process = new PointF();
        process.x = (1 - t) * point0.x + t * pointi.x;
        process.y = (1 - t) * point0.y + t * pointi.y;
        backupAdsPoints.add(process);
        if(m == 1)
        {
          mAdsLinePath.moveTo(process.x,process.y);
        }
        else
        {
          mAdsLinePath.lineTo(process.x,process.y);
        }
        canvas.drawCircle(Offset(process.x, process.y),1,adsPointPaint1);
      }
      canvas.drawPath(mAdsLinePath,adsLinePaint1);
      adsPoints.clear();
      for(int m=0;m<backupAdsPoints.length;m++)
      {
        adsPoints.add(backupAdsPoints[m]);
      }
      backupAdsPoints.clear();
    }

    //mBezierPaint沿mBezierPath绘制bezier曲线,mBezierPointPaint绘制bezier曲线尾点
    mBezierPath.reset();
    if(drawPoints.length > 1)
    {
      mBezierPath.moveTo(pointHead.x,pointHead.y);
      for(int i=1;i<drawPoints.length;i++)
      {
        PointF pointi = drawPoints[i];
        mBezierPath.lineTo(pointi.x,pointi.y);
      }
      canvas.drawPath(mBezierPath,mBezierPaint);
      PointF tailPoint = drawPoints[drawPoints.size()-1];
      canvas.drawCircle(Offset(tailPoint.x,tailPoint.y),1,mBezierPointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {

  }

  void initView()
  {
    if(_level < 2){
      return;
    }
    if (mPoints == null || mPoints.length != _level + 1) {
      var colorList = [
        Color(0x602828FF),
        Color(0x600072E3),
        Color(0x6000CACA),
        Color(0x6002Df82),
        Color(0x6000DB00),
        Color(0x608CEA00),
        Color(0x60C4C400),
        Color(0x60D9B300),
        Color(0x60FF8000)
      ];

      mControlLinePaint = new Paint();
      mControlLinePaint.color = Colors.grey;
      mControlLinePaint.strokeWidth = 8;
      mControlLinePaint.style = PaintingStyle.stroke;
      mControlLinePaint.isAntiAlias = true;
      mControlLinePaint.strokeCap = StrokeCap.round;

      mControlPointPaint = new Paint();
      mControlPointPaint.color = Colors.black;
      mControlPointPaint.strokeWidth = 4;
      mControlPointPaint.style = PaintingStyle.stroke;
      mControlPointPaint.isAntiAlias = true;
      mControlPointPaint.strokeCap = StrokeCap.round;

      mBezierPaint = new Paint();
      mBezierPaint.color = Colors.red;
      mBezierPaint.strokeWidth = 8;
      mBezierPaint.style = PaintingStyle.stroke;
      mBezierPaint.isAntiAlias = true;
      mBezierPaint.strokeCap = StrokeCap.round;

      mBezierPointPaint = new Paint();
      mBezierPointPaint.color = Colors.black;
      mBezierPointPaint.strokeWidth = 10;
      mBezierPointPaint.style = PaintingStyle.fill;
      mBezierPointPaint.isAntiAlias = true;
      mBezierPointPaint.strokeCap = StrokeCap.round;

      mTextPaint = new Paint();
      mTextPaint.color = Colors.black;
      mTextPaint.strokeWidth = 10;
      mTextPaint.style = PaintingStyle.fill;
      mTextPaint.isAntiAlias = true;
      mTextPaint.strokeCap = StrokeCap.round;

      for (int i = 0; i < _level - 1; i++) {
        Paint adsLinePaint1 = new Paint();
        adsLinePaint1.color = colorList[i];
        adsLinePaint1.strokeWidth = 8;
        adsLinePaint1.style = PaintingStyle.stroke;
        adsLinePaint1.isAntiAlias = true;
        adsLinePaint1.strokeCap = StrokeCap.round;
        adsLinePaints.add(adsLinePaint1);

        Paint adsPointPaint1 = new Paint();
        adsPointPaint1.color = colorList[i];
        adsPointPaint1.strokeWidth = 10;
        adsPointPaint1.style = PaintingStyle.fill;
        adsPointPaint1.isAntiAlias = true;
        adsPointPaint1.strokeCap = StrokeCap.round;
        adsPointPaints.add(adsPointPaint1);
      }

      mControlPath = new Path();
      mBezierPath = new Path();
      mAdsLinePath = new Path();

      constValue = null;
      if (_level == 2) {
        constValue = [1, 2, 1];
      }
      else if (_level == 3) {
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

      mGridPaint = new Paint();
      mGridPaint.color = Color(0x60707070);
      mGridPaint.strokeWidth = 4;
      mGridPaint.style = PaintingStyle.stroke;
      mGridPaint.isAntiAlias = true;
      mGridPaint.strokeCap = StrokeCap.round;
    }

    if (mPoints.length != _level + 1 || initCheck == true)
    {
      mPoints.clear();
      //初始化各点位置
      double gap = 1000 / _level;
      for (int i = 0; i <= _level; i++) {
        double xpos = centerX - 500 + gap * i;
        double ypos = centerY;
        if(i == 1 || i == 2){
          ypos = 200;
        }
        var point = PointF(x: xpos, y: ypos);
        mPoints.add(point);
      }
    }
    drawPoints.clear();
    drawPoints.add(mPoints[0]);
  }
}