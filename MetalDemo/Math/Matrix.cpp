//
//  Matrix.cpp
//  MetalDemo
//
//  Created by Yang Zhang on 2022/5/15.
//

#ifndef Matrix_cpp
#define Matrix_cpp

#include "Matrix.hpp"
using namespace zy;

template <typename Type, int Row, int Col>
 Matrix<Type, Row, Col>::Matrix(Type m) {
     for (int i = 0; i < Row; i++)
         for (int j = 0; j < Col; j++)
             _matrix[i][j] = m;
}

template <typename Type, int Row, int Col>
 Matrix<Type, Row, Col>::Matrix(const Type (&m)[Row][Col]) {
     for (int i = 0; i < Row; i++)
         for (int j = 0; j < Col; j++)
             _matrix[i][j] = m[i][j];
}

#pragma mark - Operator

template <typename Type, int Row, int Col>
const Matrix<Type, Row, Col>&  Matrix<Type, Row, Col>::operator+=(const Matrix<Type, Row, Col> &m) {
    for (int i = 0; i < Row; i++) 
        for (int j = 0; j < Col; j++)
            _matrix[i][j] = m[i][j];

    return *this;
}

#endif
