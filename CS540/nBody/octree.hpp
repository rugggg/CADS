//octree.hpp
#ifndef OCTREE_H
#define OCTREE_H


#include <string>
#include <vector>
#include <list>

struct NodePoint
{
    float x,y,z;
};

struct Node
{
    NodePoint location;
    bool placed;
};

struct Bound 
{
    float upper,lower;
};

struct NodeBounds 
{
    Bound xBound,yBound,zBound;
};
struct OctreeNode
{
    NodePoint center;
    double nodeSize; 
};

class Octree
{
    public:
        Octree(NodePoint center,const double size, std::list<NodePoint> points);
        Octree(NodePoint center,const double size, Octree* parent, std::list<NodePoint> points);
       // Octree(const Octree& copy);
       // Octree& operator=(const Octree& copy);
        ~Octree();
  
        double getSize();
        NodePoint getCenter();
        int getDepth();
        NodeBounds getBounds();
        std::list<NodePoint> getPoints();
        void split(std::list<NodePoint> points);
        void traverse();
        void printSpaces();
        void insertPoint(NodePoint np);
        void printBounds();
        bool inBounds(NodePoint pointToCheck); 
        int id;
        static int maxDepth;
        static int instance_count;

    private:
	    NodePoint m_center;
        double m_size;
        NodeBounds m_nodeBounds;
        std::vector<Octree> m_children;
        std::list<NodePoint> m_points;
        Octree* m_parent;
        int m_depth;
        void setBounds();
};


#endif
