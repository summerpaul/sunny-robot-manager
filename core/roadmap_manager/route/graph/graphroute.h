#ifndef GRAPHROUTE_H
#define GRAPHROUTE_H

#include <vector>
#include "vertex.h"
#include "ipathsearch.h"
#include "roadmap_manager/route/agvpoint.h"
#include "roadmap_manager/route/roadmap_data.h"
using std::vector;

enum SearchStrategy
{
    SEARCH_DIJKSTRA,
    SEARCH_ASTAR
};

class CGraphRoute
{
    typedef vector<CVertex*>::iterator IterVertex;

public:
    CGraphRoute(SearchStrategy searchSty = SEARCH_DIJKSTRA);
    ~CGraphRoute();
    void Initialize();
    bool buildGraph( const vector<AgvPoint> &listPoints, const map<int,Lane>& map_lanes);

    CVertex* getVertex(int id);
    WEIGHT SearchShortestPath(int startPoint, int endPoint, bool isLoaded = false);

    void getShortestPathByPoint(list<int>& listOutPathPoint);
    void getShortestPathBySegment(list<int>& listOutPathSegment);
private:
    int BinarySearch(int sourceId);
private:
    int m_startPoint;
    int m_endPoint;
    bool m_bStopCalc;
    SearchStrategy m_searchStrategy;
    vector<CVertex*> m_vecVertices;
    IPathSearch* m_pPathSearch;
};

#endif // GRAPHROUTE_H
