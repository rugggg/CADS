//octree.cpp

#include "octree.hpp"
#include <iostream>
#include <math.h>

Octree::Octree(NodePoint center, const double size){
    m_center = center;
    m_size = size;    
    setBounds();
}

Octree::Octree(NodePoint center, const double size, Octree *parent){
    m_center = center;
    m_size = size;    
    m_parent = parent;
}

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

NodeBounds Octree::getBounds(){
    return m_nodeBounds;
}

Octree::~Octree(){}


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

