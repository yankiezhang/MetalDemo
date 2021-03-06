//
//  ShaderTypes.h
//  MetalDemo
//
//  Created by Yang Zhang on 2022/5/10.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#ifdef __METAL_VERSION__
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#define NSInteger metal::int32_t
#else
#import <Foundation/Foundation.h>
#endif

#include <simd/simd.h>

typedef struct
{
    vector_float2 pos;
} Vertex;

#endif /* ShaderTypes_h */
