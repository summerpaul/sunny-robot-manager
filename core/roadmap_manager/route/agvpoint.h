#ifndef AGVPOINT_H
#define AGVPOINT_H
#include <list>
#include "common/vector2.h"

using std::list;
class AgvPoint
{
public:
  AgvPoint();
  AgvPoint(int id, Vector2 pos, double angle = 0);
  ~AgvPoint();
  void addInComeSegment(int segID);
  void addOutComeSegment(int segID);
  void addBindStation(int stnID);
  int getID(){return m_id;}
  Vector2& getPosition(){return m_position;}

  list<int>& getBindStationIDList() {return m_listBindStnId;}
  list<int>& getInSegmentList() {return m_listInSegment;}
  list<int>& getOutSegmentList() {return m_listOutSegment;}

private:
  int m_id;
  Vector2 m_position;
  double m_angle;
  list<int> m_listBindStnId;
  list<int> m_listInSegment;
  list<int> m_listOutSegment;



};

#endif // AGVPOINT_H
