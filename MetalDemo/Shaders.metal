//
//  Shaders.metal
//  MetalDemo
//
//  Created by Yang Zhang on 2022/5/10.
//

#include <metal_stdlib>
#include "ShaderTypes.h"

using namespace metal;

typedef struct
{
    float4 position [[position]];
    float2 texCoord;
} ColorInOut;

vertex ColorInOut vertexShader(constant Vertex *vertexArr [[buffer(0)]],
                               uint vid [[vertex_id]])
{
    ColorInOut out;
    
    float4 position = vector_float4(vertexArr[vid].pos, 0, 1.0);
    out.position = position;
    
    return out;
}

fragment float4 fragmentShader(ColorInOut in [[stage_in]])
{
    return float4(1.0, 0, 0, 0);
}
