#include "graph.h"

Graph::Graph()
{

}
Graph::~Graph(){
  m_adj_list.clear();

}
void Graph::addVertex(const CVertex& vertex)
{
  m_adj_list.insert(std::pair<int, CVertex>(vertex.getID(), vertex));
}
