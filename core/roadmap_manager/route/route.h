#ifndef ROUTE_H
#define ROUTE_H
#include <QJsonObject>
#include <QJsonArray>
#include "graph/graphroute.h"
#include "common/vector2.h"
#include "agvpoint.h"
#include "roadmap_data.h"
#include <QList>
class Route
{
public:
  Route();
  ~Route();
  bool init(const QJsonObject& roadmap);
  void plan(int startId, int endId, QList<int>& listOutPathSegment);
  void jsonTonode(const QJsonObject& json_node_in, Node &node_out);
  void jsonToNodes(const QJsonArray& json_nodes_in, map<int, Node>& map_nodes_out);
  void jsonToLane(const QJsonObject& json_lane_in, const map<int, Node>& map_nodes_in, Lane &lane_out);
  void jsonToLanes(const QJsonArray& json_lanes_in, const map<int, Node>& map_nodes_in, map<int,Lane>& map_lanes_out);

private:
  CGraphRoute m_graph_route;
};

#endif // ROUTE_H
