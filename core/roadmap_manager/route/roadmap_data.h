#ifndef ROADMAP_DATA_H
#define ROADMAP_DATA_H
#include <string>

struct Node{
  int id;
  int mark_pose;
  double x;
  double y;
  double yaw;
  std::string description;
  int ahead_node;
  int post_node;
  std::string type;
  Node():
  id(-1), mark_pose(-1), x(0), y(0), yaw(0),
  description("RoadPoint"), ahead_node(-1),
  post_node(-1), type(""){}
};

struct LaneShape{
  std::string  lane_type; // 'poly3' 'line'
  float p1;
  float p2 ;
  float hdg;
  float length;
  LaneShape():
    lane_type("line"),
    p1(0),
    p2(0),
    hdg(0),
    length(0){}

};
struct LaneInfo {
  float speed ;
  int motion_type;
  bool obstacle_avoid ;
  int extra_cost ;
  int qr_code ;
  bool infrared ;
  int heading ;
  int avoid_level ;
  LaneInfo():
  speed(0),
  motion_type(1),
  obstacle_avoid(false),
  extra_cost(0),
  qr_code(0),
  infrared(false),
  heading(0),
  avoid_level(0){}
};

struct Lane{
  int id;
  Node BN;
  Node FN;
  LaneInfo lane_info;
  LaneShape lane_shape;
};
#endif // ROADMAP_DATA_H
