//
//  Vector.cpp
//  MetalDemo
//
//  Created by Yang Zhang on 2022/5/15.
//

#ifndef Vector_cpp
#define Vector_cpp

#include "Vector.hpp"

using namespace zy;

template <typename Type, int Size>
 Vector<Type, Size>::Vector(Type a) {
     for (int i = 0; i < Size; i++) {
         array[i] = a;
     }
}

#endif
