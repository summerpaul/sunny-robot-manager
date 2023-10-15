#include "graphroute.h"
#include "dijkstrasearch.h"
CGraphRoute::CGraphRoute(SearchStrategy searchSty) : m_startPoint(-1), m_endPoint(-1), m_searchStrategy(searchSty),
                                                     m_bStopCalc(false)
{
  if (m_searchStrategy == SEARCH_DIJKSTRA)
  {
    m_pPathSearch = new CDijkstraSearch();
  }
}
CGraphRoute::~CGraphRoute()
{
}

//搜索的初始化
void CGraphRoute::Initialize()
{
  for (IterVertex iter = m_vecVertices.begin(); iter != m_vecVertices.end(); ++iter)
  {
    (*iter)->setKnown(false);
    (*iter)->setTotalWeight(INFINITY);
    (*iter)->setRealTotalWeight(INFINITY);
  }

}

//构建图
bool CGraphRoute::buildGraph( const vector<AgvPoint> &listPoints, const map<int,Lane>& map_lanes)
{
  m_vecVertices.clear();
  // std::cout << " in buildGraph listPoints size is " <<  listPoints.size() << std::endl;
  for (auto point : listPoints)
  {
    // std::cout << "in build graph loop " << std::endl;
    Vector2 pos = point.getPosition();
    CVertex *vertex = new CVertex();
    vertex->setID(point.getID());
    vertex->setCoordinate(pos.x, pos.y);
    // std::cout << "vertex id is " << vertex->getID() << std::endl;
    //    std::list<int>& bindStns = point.getBindStationIDList();
    list<int> listOutSegment = point.getOutSegmentList();
    for (auto lane_id : listOutSegment)
    {
      auto lane = map_lanes.at(lane_id);
      int FNID = lane.FN.id;
      CAdjacentSegment adjSegment;
      adjSegment.id = lane.id;
      adjSegment.weight = lane.lane_shape.length;
      vertex->addAdjacentPoint(FNID);
      vertex->addAdjacentSegment(FNID, adjSegment);
    }
    m_vecVertices.push_back(vertex);
  }
  // std::cout << " in buildGraph m_vecVertices size is " << m_vecVertices.size() << std::endl;
  return true;
}

WEIGHT CGraphRoute::SearchShortestPath(int startPoint, int endPoint, bool isLoaded)
{
  m_startPoint = startPoint;
  m_endPoint = endPoint;

  // std::cout << "in CGraphRoute "
  // << " start id is " << startPoint << " end id is " << endPoint << std::endl;
  Initialize();
  return m_pPathSearch->search(this, startPoint, endPoint, isLoaded);
}
void CGraphRoute::getShortestPathByPoint(list<int> &listOutPathPoint)
{
  listOutPathPoint.clear();
  CVertex *curVertex = getVertex(m_endPoint);
  CVertex *prevVertex = nullptr;
  if (nullptr == curVertex)
  {
    return;
  }

  int curId = curVertex->getID();
  while (curId != m_startPoint)
  {
    listOutPathPoint.push_front(curId);
    prevVertex = getVertex(curVertex->getPrevId());
    if (nullptr == prevVertex)
    {
      listOutPathPoint.clear();
      return;
    }
    curId = prevVertex->getID();
    curVertex = prevVertex;
  }
  listOutPathPoint.push_front(m_startPoint);
}
void CGraphRoute::getShortestPathBySegment(list<int> &listOutPathSegment)
{
  listOutPathSegment.clear();
  listOutPathSegment.clear();

  CVertex *curVertex = getVertex(m_endPoint);
  CVertex *prevVertex = nullptr;
  int curId = curVertex->getID();
  while (curId != m_startPoint)
  {
    prevVertex = getVertex(curVertex->getPrevId());
    if (nullptr == prevVertex) //*--- 20161228 By TsaiPing
    {
      listOutPathSegment.clear();
      return;
    }

    listOutPathSegment.push_front(prevVertex->getAdjacentSegmentID(curId));
    curVertex = prevVertex;
    curId = prevVertex->getID();
  }
}

int CGraphRoute::BinarySearch(int sourceId)
{
  if (sourceId <= 0)
    return -1;

  bool found = false;
  int low = 0, high = m_vecVertices.size() - 1;
  int mid = -1;
  while (low <= high)
  {
    mid = (low + high) / 2;
    if (m_vecVertices[mid]->getID() == sourceId)
    {
      found = true;
      break;
    }
    if (m_vecVertices[mid]->getID() < sourceId)
      low = mid + 1;
    else
      high = mid - 1;
  }

  if (found)
    return mid;
  else
    return -1;
}
CVertex *CGraphRoute::getVertex(int id)
{
  int index = BinarySearch(id);
  if (index != -1)
    return m_vecVertices[index];

  return nullptr;
}
