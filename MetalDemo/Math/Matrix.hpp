//
//  Matrix.hpp
//  MetalDemo
//
//  Created by Yang Zhang on 2022/5/15.
//

#ifndef Matrix_hpp
#define Matrix_hpp

#include <stdio.h>

#include "Vector.hpp"
#include <stdexcept>

namespace zy {

template <typename Type, int Row, int Col>
class Matrix {
        
public:
    Matrix<Type, Row, Col>(const Type &m = 0);
    Matrix<Type, Row, Col>(const Type (&m)[Row][Col]);
    
    const Type (*operator &() const )[Row][Col] { return &_matrix; }
    const Type (&operator[](int i) const )[Col] { return _matrix[i];}
    const Matrix<Type, Row, Col>& operator+=(const Matrix<Type, Row, Col>& m);

private:
    Type _matrix[Row][Col];
};

template <typename Type, int Row, int Col>
class Matrix<Type*, Row, Col> {
    
public:
    Matrix<Type*, Row, Col>(Type (*p)[Row][Col] = NULL):_pMatrix(p){}
    
    bool operator !() const { return _pMatrix == NULL ? true : false; }
    const Type (&operator[](int i) const )[Col] { if (!*this) throw std::runtime_error("Null Pointer XXX"); return (*_pMatrix)[i]; }
    const Matrix<Type*, Row, Col>& operator+=(const Type &a);
    
private:
    Type (*_pMatrix)[Row][Col];
    
};

}

#include "Matrix.cpp"

#endif /* Matrix_hpp */
