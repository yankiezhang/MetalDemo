//
//  MTKViewDemo.m
//  MetalDemo
//
//  Created by Yang Zhang on 2022/5/9.
//

#import "MTKViewDemo.h"
#import <Metal/MTLDevice.h>
#import "ShaderTypes.h"
#import "Vector.hpp"

@interface MTKViewDemo()
{
    id<MTLLibrary> _defaultLibrary;
    id<MTLFunction> _vertexFunction;
    id<MTLFunction> _fragmentFunction;
    id<MTLRenderPipelineState> _pipelineState;
    id<MTLDepthStencilState> _depthState;
    id<MTLCommandQueue> _commandQueue;
    id<MTLBuffer> _vertexBuffer;
}

@end

@implementation MTKViewDemo

- (instancetype)initWithCoder:(NSCoder *)coder
{
    zy::Vector<int, 3> v;

    self = [super initWithCoder:coder];
    if (self) {
        self.depthStencilPixelFormat = MTLPixelFormatDepth32Float_Stencil8;
        self.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
        self.sampleCount = 1;
        self.backgroundColor = UIColor.blackColor;
        NSLog(@"Will init MTKView for Demo");
    }
    return [[[self initDevice] bind] load];
}

- (nonnull instancetype)initDevice
{
    self.device = MTLCreateSystemDefaultDevice();
    if (!self.device) {
        NSLog(@"Create GPU device fail");
        return nil;
    }
    _defaultLibrary = self.device.newDefaultLibrary;
    _vertexFunction = [_defaultLibrary newFunctionWithName:@"vertexShader"];
    _fragmentFunction = [_defaultLibrary newFunctionWithName:@"fragmentShader"];
    
    if (!_defaultLibrary || !_vertexFunction || !_fragmentFunction) {
        NSLog(@"Create default library failed");
        return nil;
    }
    
    return self;
}

- (nonnull instancetype)bind
{
    if (!self)
        return self;

    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    
    pipelineStateDescriptor.label = @"MyPipeline";
    
    pipelineStateDescriptor.sampleCount = self.sampleCount;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.colorPixelFormat;
    pipelineStateDescriptor.depthAttachmentPixelFormat = self.depthStencilPixelFormat;
    pipelineStateDescriptor.stencilAttachmentPixelFormat = self.depthStencilPixelFormat;
    
    NSAssert(_vertexFunction != nil, @"vertexFunction is nil");
    pipelineStateDescriptor.vertexFunction = _vertexFunction;
    
    NSAssert(_fragmentFunction != nil, @"vertexFunciton is nil");
    pipelineStateDescriptor.fragmentFunction = _fragmentFunction;
    
    NSError *error = nil;
    
    NSAssert(self.device != nil, @"GPU device is nil");
    _pipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
    
    if (!_pipelineState) {
        NSLog(@"Failed to create pipeline with error %@", error);
        return nil;
    }
    
    MTLDepthStencilDescriptor *depthStateDesc = [[MTLDepthStencilDescriptor alloc] init];
    depthStateDesc.depthCompareFunction = MTLCompareFunctionLess;
    depthStateDesc.depthWriteEnabled = YES;
    
    _depthState = [self.device newDepthStencilStateWithDescriptor:depthStateDesc];
    _commandQueue = [self.device newCommandQueue];
    
    if (!_depthState || !_commandQueue) {
        NSLog(@"Create depthstate or commandqueue failed");
        return nil;
    }
    
    return self;
}

- (nonnull instancetype)load
{
    static const Vertex vert[] = {
        {{0,1.0}},
        {{1.0,-1.0}},
        {{-1.0,-1.0}},
    };
    
    _vertexBuffer = [self.device newBufferWithBytes:vert length:sizeof(vert) options:MTLResourceStorageModeShared];
    return self;
}

- (void)draw
{
    [self renderWith:[_commandQueue commandBuffer]];
}

- (void)renderWith:(nonnull id<MTLCommandBuffer>)commandBuffer {
    commandBuffer.label = @"MyCommand";
    MTLRenderPassDescriptor *renderPassDescriptor = self.currentRenderPassDescriptor;
    
    if (renderPassDescriptor == nil) {
        
        return;
    }
    
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    renderEncoder.label = @"MyRenderEncoder";
    
    [renderEncoder pushDebugGroup:@"DrawTriangle"];
    [renderEncoder setRenderPipelineState:_pipelineState];
    [renderEncoder setDepthStencilState:_depthState];
    [renderEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
    [renderEncoder popDebugGroup];
    
    [renderEncoder endEncoding];
    
    [commandBuffer presentDrawable:self.currentDrawable];
    [commandBuffer commit];
}

@end
