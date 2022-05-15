//
//  Matrix.hpp
//  MetalDemo
//
//  Created by Yang Zhang on 2022/5/15.
//

#ifndef Matrix_hpp
#define Matrix_hpp

#include <stdio.h>

namespace zy {

template <typename Type, int Row, int Col>
class Matrix {
    
public:
    Matrix<Type, Row, Col>(Type m = 0);
    Matrix<Type, Row, Col>(const Type (&m)[Row][Col]);
    
    const Type (*operator &() const)[Row][Col] { return &_matrix; }

private:
    Type _matrix[Row][Col];
};

}

#include "Matrix.cpp"

#endif /* Matrix_hpp */
