#ifndef IPATHSEARCH_H
#define IPATHSEARCH_H

#include <vector>
#include <cmath>
#include "vertex.h"

using std::vector;
class CGraphRoute;

// 比较点的权重
class Compare{
public:
  bool operator () (CVertex* v1, CVertex* v2)
  {
    return v1->getTotalWeight() > v2->getTotalWeight();
  }
};

class IPathSearch
{
public:
  IPathSearch();
  virtual ~IPathSearch();

  virtual WEIGHT search(CGraphRoute* pGraph, int startVertex, int endVertex, bool isLoaded) = 0;
  virtual WEIGHT search(vector<CVertex> vecVertices, int startVertex, int endVertex, bool isLoaded) {return INFINITY;}

};

#endif // IPATHSEARCH_H
