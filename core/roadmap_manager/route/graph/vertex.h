#ifndef VERTEX_H
#define VERTEX_H

#include <list>
#include <map>
#include <queue>

using std::list;
using std::map;
using std::queue;

typedef double WEIGHT;
constexpr WEIGHT BLOCK_WEIGHT = 200000000;

class CAdjacentSegment
{
public:
  int id;
  WEIGHT weight;
  WEIGHT incWeight;
  CAdjacentSegment():id(0), weight(0),incWeight(0)
  {
  }
};


//

class CVertex{
public:
  CVertex();
  ~CVertex();
  bool operator == (const CVertex& v){return m_id = v.m_id;}
  bool operator != (const CVertex& v){return m_id != v.m_id;}
  WEIGHT getTotalWeight() const{return m_totalWeight;}

  WEIGHT getWeight() const {return m_weight;}

  WEIGHT getAdjacentSegmentWeight(int AdjPtId){return m_mapAdjSegment[AdjPtId].weight;}
  list<int>& getAdjacentPointList() {return m_listAdjPoint;}

  void addAdjacentPoint(int adjPtId);
  void addAdjacentSegment(int adjPtId, CAdjacentSegment adjSegment);
  int getAdjacentSegmentID(int AdjPtId);

  int getID() const {return m_id;}
  void setID(int ID) {m_id = ID;}

  void setPrevId(int id){m_preId = id;}
  int getPrevId() const{return m_preId;}

  void setCoordinate(double x, double y);
  void setKnown(bool known = true){m_bKnown = known;}
  bool isKnown() const {return  m_bKnown;}
  void setTotalWeight(WEIGHT weight){m_totalWeight = weight;}
  void setRealTotalWeight(WEIGHT weight){m_realTotalWeight = weight;}


private:
  int m_id;
  double m_x,  m_y;
  bool m_isLoadPass, m_bKnown;
  WEIGHT m_totalWeight;
  WEIGHT m_realTotalWeight;
  WEIGHT m_weight;
  int m_preId;

  list<int> m_listAdjPoint;
  map<int, CAdjacentSegment> m_mapAdjSegment;
  queue<double> m_incWeight;

};


#endif // VERTEX_H
