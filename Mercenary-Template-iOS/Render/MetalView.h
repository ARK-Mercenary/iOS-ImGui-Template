//
//  MetalView.h
//  Mercenary-Rewrite
//
//  Created by Li on 3/20/25.
//

#pragma once

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface MetalView : MTKView

-(instancetype)initWithFrame:(CGRect)frame;
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;

@end
