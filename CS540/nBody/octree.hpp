//octree.hpp
#ifndef OCTREE_H
#define OCTREE_H


#include <string>
#include <vector>

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
        Octree(NodePoint center,const double size);
        Octree(NodePoint center,const double size, Octree* parent);
        Octree(const Octree& copy);
        Octree& operator=(const Octree& copy);
        ~Octree();
    
        double getSize();
        NodePoint getCenter();
        NodeBounds getBounds();
            
    
    private:
	    NodePoint m_center;
        double m_size;
        NodeBounds m_nodeBounds;
        std::vector<Octree> m_children;
        Octree* m_parent;

        void setBounds();
};


#endif
