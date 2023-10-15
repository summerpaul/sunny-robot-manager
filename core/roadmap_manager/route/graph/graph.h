#ifndef GRAPH_H
#define GRAPH_H
#include <vector>
#include "vertex.h"
#include <map>

using std::map;
class Graph
{
public:
  Graph();
  ~Graph();
  void addVertex(const CVertex& vertex);

private:
  int m_vcount; //节点的数量
  int m_ecount; //边的数量
  map<int, CVertex> m_adj_list;//存放所有点信息的邻接表


};

#endif // GRAPH_H
