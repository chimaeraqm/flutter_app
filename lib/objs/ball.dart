import 'dart:ui';

class Ball
{
  double aX; //加速度
  double aY; //加速度Y
  double vX; //速度X
  double vY; //速度Y
  double x; //点位X
  double y; //点位Y
  Color color; //颜色
  double r;//小球半径

  Ball({this.x, this.y, this.color, this.r, this.aX, this.aY, this.vX, this.vY});
}