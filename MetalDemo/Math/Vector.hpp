//
//  Vector.hpp
//  MetalDemo
//
//  Created by Yang Zhang on 2022/5/15.
//

#ifndef Vector_hpp
#define Vector_hpp

#include <stdio.h>

namespace zy {

template <typename Type, int Size>
class Vector {
    
public:
    Vector<Type, Size>(Type a = 0);
    
private:
    Type array[Size];
    
};

#include "Vector.cpp"
}

#endif /* Vector_hpp */
