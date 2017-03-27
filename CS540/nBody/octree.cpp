//octree.cpp

#include "octree.hpp"
#include <iostream>
#include <math.h>

Octree::Octree(NodePoint center, const double size){
    m_center = center;
    m_size = size;
    m_depth = 0;
    setBounds();
}

Octree::Octree(NodePoint center, const double size, Octree *parent){
    m_center = center;
    m_size = size;    
    m_depth = parent->getDepth()+1;
    m_parent = parent;
}

Octree::~Octree(){}

void Octree::setBounds(){
    //use our size and center to compute and store boundaries
    double distance = cbrt(m_size)/2;
    m_nodeBounds.xBound.upper = m_center.x + distance;
    m_nodeBounds.xBound.lower = m_center.x - distance;
    m_nodeBounds.yBound.upper = m_center.y + distance;
    m_nodeBounds.yBound.lower = m_center.y - distance;
    m_nodeBounds.zBound.upper = m_center.z + distance;
    m_nodeBounds.zBound.lower = m_center.z - distance;
}

double Octree::getSize(){
    return m_size;
}

NodePoint Octree::getCenter(){
    return m_center;
}

int Octree::getDepth(){
    return m_depth;
}

NodeBounds Octree::getBounds(){
    return m_nodeBounds;
}

void Octree::split(int maxDepth,std::vector<NodePoint> points){
    //1 check if we have less than the minimum number of points in us
    //also check if we are past max depth
    //if either of those are true we are a leaf
    if(m_depth >= maxDepth || points.size() <= 1){
        for(int i = 0; i<points.size(); ++i){
            //we take the node pointer and place it here  
        }
    }
    //else: we take split into a child octree and pass the points forward
    //into that tree and place the current octree into the new children
    //to split we should start from one corner of the cube, so the lower x,y,z
    //the size is 1/8 the last size
    
    double childSize = m_size/8;
    //we now have the size, now we need the four centers
    childDistance = cbrt(childSize)/2
    NodePoint nwf_childCenter,swf_childCenter; 
    nwf_childCenter.x = m_center.x+childDistance;
    nwf_childCenter.y = m_center.y+childDistance;
    nwf_childCenter.z = m_center.z+childDistance;
    
    
}

int main(){
    std::cout<<"Main"<<std::endl;
    NodePoint center;
    center.x = 0;
    center.y = 0;
    center.z = 0;
    Octree init_octree = Octree(center,100);
    
    std::cout<<init_octree.getSize()<<std::endl;
    NodePoint currentCenter = init_octree.getCenter();
    std::cout<<currentCenter.x<<" "<<currentCenter.y<<" "<<currentCenter.y<<std::endl;
    
    NodeBounds nb = init_octree.getBounds();
    std::cout<<nb.xBound.upper<<":"<<nb.xBound.lower<<std::endl<<nb.yBound.upper<<":"<<nb.yBound.lower<<std::endl<<nb.zBound.upper<<":"<<nb.zBound.lower<<std::endl;
}

