#ifndef DIJKSTRASEARCH_H
#define DIJKSTRASEARCH_H

#include "ipathsearch.h"
#include <queue>

using std::priority_queue;

class CDijkstraSearch : public IPathSearch
{
public:
  CDijkstraSearch();
  virtual ~CDijkstraSearch();
  virtual WEIGHT search(CGraphRoute* pGraph, int startVertexId, int endVertexId, bool isLoaded);

  WEIGHT getCurrentVertexWeight(CVertex* currentVertex, const CVertex* adjVertex);
private:
  list<int> m_lisrOutPath;
};

#endif // DIJKSTRASEARCH_H
