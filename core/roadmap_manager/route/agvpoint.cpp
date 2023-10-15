#include "agvpoint.h"

AgvPoint::AgvPoint()
{

}
AgvPoint::AgvPoint(int id, Vector2 pos, double angle ):
m_id(id), m_position(pos), m_angle(angle){

}

AgvPoint::~AgvPoint(){
  m_listBindStnId.clear();
  m_listInSegment.clear();
  m_listOutSegment.clear();
}

void AgvPoint::addInComeSegment(int segID){
  m_listInSegment.push_back(segID);

}
void AgvPoint::addOutComeSegment(int segID){
  m_listOutSegment.push_back(segID);

}
void AgvPoint::addBindStation(int stnID){
  m_listBindStnId.push_back(stnID);

}
