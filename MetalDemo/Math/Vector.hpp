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
    
    const Type& operator[](int i) const { return _array[i]; }
    
private:
    Type _array[Size];
};

#include "Vector.cpp"
}

#endif /* Vector_hpp */
