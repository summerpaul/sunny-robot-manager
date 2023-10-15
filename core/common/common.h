#ifndef COMMON_H
#define COMMON_H
#include <cmath>

#define M_PI 3.14159265358979323846

template <typename T>
static double calPose2Pose(const T &pose1, const T &pose2)
{
  double dist = sqrt((pose1.x - pose2.x) * (pose1.x - pose2.x) + (pose1.y - pose2.y) * (pose1.y - pose2.y));

  return dist;
}

static double deg2rad(double x)
{
  return x * M_PI / 180;
}

static double rad2deg(double x)
{
  return x * 180 / M_PI;
}

static double mdeg2rad(double x)
{
  return x * M_PI / 180 / 1000;
}

static double rad2mrad(double x)
{
  return x * 180 * 1000 / M_PI;
}
#endif // COMMON_H
