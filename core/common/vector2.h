#ifndef VECTOR2_H
#define VECTOR2_H

//基础的二维向量点
class Vector2
{
public:
  Vector2():x(0), y(0){}
  Vector2(double x, double y):x(x), y(y){}
public:
  double x;
  double y;
};

#endif // VECTOR2_H
