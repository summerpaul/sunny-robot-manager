#include "vertex.h"

CVertex::CVertex():
  m_id(-1), m_x(0), m_y(0),
  m_isLoadPass(true),m_bKnown(false),
  m_totalWeight(0), m_realTotalWeight(0),m_weight(0),
  m_preId(-1){

}

CVertex::~CVertex(){
  m_listAdjPoint.clear();
  m_mapAdjSegment.clear();
}
void CVertex::setCoordinate(double x, double y)
{
  m_x = x;
  m_y = y;
}
void CVertex::addAdjacentPoint(int adjPtId)
{
  m_listAdjPoint.push_back(adjPtId);

}
void CVertex::addAdjacentSegment(int adjPtId, CAdjacentSegment adjSegment)
{
  m_mapAdjSegment[adjPtId] = adjSegment;
}
int CVertex::getAdjacentSegmentID(int AdjPtId)
{
  return m_mapAdjSegment[AdjPtId].id;
}
