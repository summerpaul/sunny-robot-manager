#include "dijkstrasearch.h"
#include "graphroute.h"
#include <algorithm>
CDijkstraSearch::CDijkstraSearch()
{

}

CDijkstraSearch::~CDijkstraSearch(){
  m_lisrOutPath.clear();
}

WEIGHT CDijkstraSearch::search(CGraphRoute* pGraph, int startVertexId, int endVertexId, bool isLoaded)
{
//  auto startVertex =


  auto startVertex = pGraph->getVertex(startVertexId);
  auto endVertex = pGraph->getVertex(endVertexId);


  if(startVertex == nullptr || endVertex == nullptr)
  {
    return INFINITY;
  }

  //起始点的cost为0
  startVertex->setTotalWeight(0);

  vector<CVertex*> openList;
  openList.push_back(startVertex);

  CVertex* v;
  while (!openList.empty()) {
    v = openList.back();
    openList.pop_back();
    if( v == endVertex){
      break;
    }
    if(v->isKnown()){
      continue;
    }
    v->setKnown();
    list<int> listAdjPoint = v->getAdjacentPointList();//寻找新的相邻的点

    for (auto vertex_id:listAdjPoint)
    {
      CVertex *w = pGraph->getVertex(vertex_id);
      if(! w->isKnown())
      {
        WEIGHT weight = v->getTotalWeight() +getCurrentVertexWeight(v, w) + w->getWeight();
        if(weight < w->getTotalWeight())
        {
          w->setTotalWeight(weight);
          w->setPrevId(v->getID());
          openList.push_back(w);
        }
      }

    }
    std::sort(openList.begin(), openList.end(), Compare());



  }
  return endVertex->getTotalWeight();


}

WEIGHT CDijkstraSearch::getCurrentVertexWeight(CVertex* currentVertex, const CVertex* adjVertex)
{
  WEIGHT retWeight =INFINITY;
  retWeight = currentVertex->getAdjacentSegmentWeight(adjVertex->getID());
  return  retWeight;

}
