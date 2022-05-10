//
//  MTKViewDemo.m
//  MetalDemo
//
//  Created by Yang Zhang on 2022/5/9.
//

#import "MTKViewDemo.h"
#import <Metal/MTLDevice.h>
#import "ShaderTypes.h"

@interface MTKViewDemo()
{
    id<MTLLibrary> _defaultLibrary;
    id<MTLFunction> _vertexFunction;
    id<MTLFunction> _fragmentFunction;
    id<MTLRenderPipelineState> _pipelineState;
    id<MTLDepthStencilState> _depthState;
    id<MTLCommandQueue> _commandQueue;
}

@end

@implementation MTKViewDemo

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"Will init MTKView for Demo");
    }
    return [[self initDevice] bind];
}

- (nonnull instancetype)initDevice
{
    NSAssert(self.device != nil, @"GPU of view is nil");
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
    
    NSAssert(self.device, @"device is nil");
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
    
    return self;
}

@end
