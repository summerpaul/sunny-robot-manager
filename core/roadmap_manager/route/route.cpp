#include "route.h"
Route::Route()
{

}
Route::~Route()
{

}
bool Route::init(const QJsonObject& roadmap)
{
    auto lanes = roadmap["lanes"].toArray();
    auto nodes = roadmap["nodes"].toArray();
    QJsonArray lanes_;
    map<int, Node> map_nodes;
    map<int,Lane> map_lanes;

    jsonToNodes(nodes, map_nodes);
    jsonToLanes(lanes, map_nodes, map_lanes);
    vector<AgvPoint> listPoint;


    if(map_nodes.size() == 0 || map_nodes.size()==0){
        return false;
    }
    for (auto node : map_nodes) {
        Vector2 position;
        position.x = node.second.x;
        position.y = node.second.y;
        int id = node.first;
        AgvPoint agvPoint(id, position);
        for(auto lane:map_lanes){
            if(id == lane.second.BN.id){
                agvPoint.addOutComeSegment(lane.second.id);
                agvPoint.addBindStation(lane.second.FN.id);
            }
            if(id == lane.second.FN.id){
                agvPoint.addInComeSegment(lane.second.id);
                agvPoint.addBindStation(lane.second.BN.id);
            }
        }
        listPoint.push_back(agvPoint);

    }
    return m_graph_route.buildGraph(listPoint, map_lanes);

}

void Route::plan(int startId, int endId, QList<int>& listOutPathSegment)
{
    listOutPathSegment.clear();

  auto result = m_graph_route.SearchShortestPath(startId, endId);
  if(result == INFINITY )
  {
      return;

  }
  list<int> result_list;
  m_graph_route.getShortestPathBySegment(result_list);
  for(auto i : result_list){
      listOutPathSegment.push_back(i);
  }
  result_list.clear();
}

void Route::jsonTonode(const QJsonObject& json_node_in, Node &node_out)
{
    node_out.id = json_node_in["id"].toInt();
    node_out.x = json_node_in["x"].toDouble();
    node_out.y = json_node_in["y"].toDouble();
    node_out.yaw = json_node_in["yaw"].toDouble();
    node_out.description = json_node_in["description"].toString().toStdString();
}
void Route::jsonToNodes(const QJsonArray& json_nodes_in, map<int, Node>& map_nodes_out)
{
    if(json_nodes_in.size() == 0){
        return;
    }
    for (auto json_node : json_nodes_in){
        int id = json_node.toObject()["id"].toInt();
        Node node;
        jsonTonode(json_node.toObject(), node);
        map_nodes_out.insert(std::pair<int, Node>(id, node));
    }


}
void Route::jsonToLane(const QJsonObject& json_lane_in, const map<int, Node>& map_nodes_in, Lane &lane_out)
{
    int BNID = json_lane_in["BNID"].toInt();
    int FNID = json_lane_in["FNID"].toInt();
    lane_out.BN = map_nodes_in.at(BNID);
    lane_out.FN = map_nodes_in.at(FNID);
    LaneShape shape;
    shape.p1 = json_lane_in["p1"].toDouble();
    shape.p2 = json_lane_in["p2"].toDouble();
    shape.hdg = json_lane_in["hdg"].toDouble();
    shape.length = json_lane_in["length"].toDouble();
    shape.lane_type = json_lane_in["lane_type"].toString().toStdString();


    LaneInfo info;
    info.avoid_level = json_lane_in["avoid_level"].toInt();
    info.infrared = json_lane_in["infrared"].toInt();
    info.speed = json_lane_in["speed"].toDouble();
    info.motion_type = json_lane_in["motion_type"].toInt();
    info.qr_code = json_lane_in["qr_code"].toInt();
    info.extra_cost = json_lane_in["extra_cost"].toInt();
    info.heading = json_lane_in["heading"].toInt();
    lane_out.lane_shape = shape;
    lane_out.lane_info = info;
    lane_out.id = json_lane_in["id"].toInt();

}
void Route::jsonToLanes(const QJsonArray& json_lanes_in, const map<int, Node>& map_nodes_in, map<int,Lane>& map_lanes)
{
    if(json_lanes_in.size()==0)
    {
        return;
    }

    for(auto json_lane : json_lanes_in)
    {
        int id = json_lane.toObject()["id"].toInt();
        Lane lane;
        jsonToLane(json_lane.toObject(), map_nodes_in, lane);
        map_lanes.insert(std::pair<int, Lane>(id, lane));
    }



}
