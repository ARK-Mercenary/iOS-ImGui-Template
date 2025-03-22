//
//  MetalView.mm
//  Mercenary-Rewrite
//
//  Created by Li on 3/20/25.
//

#import "MetalView.h"

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#include <objc/runtime.h>

#include "../ImGui/imgui.h"
#include "../ImGui/imgui_internal.h"
#include "../ImGui/imgui_impl_metal.h"

@implementation MetalView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    ImGuiContext* Context = ImGui::GetCurrentContext();
    
    if (Context)
    {
        const ImVector<ImGuiWindow*>& Windows = Context->Windows;
        for (int i = 0; i < Windows.Size; ++i)
        {
            ImGuiWindow* CurrentWindow = Windows[i];
            if (!CurrentWindow)
                continue;

            if (CurrentWindow->Active && !(CurrentWindow->Flags & ImGuiWindowFlags_NoInputs))
            {
                CGRect touchableArea = CGRectMake(CurrentWindow->Pos.x, CurrentWindow->Pos.y, CurrentWindow->Size.x, CurrentWindow->Size.y);
                if (CGRectContainsPoint(touchableArea, point)) {
                    return [super pointInside:point withEvent:event];
                }
            }
        }
    }
    return NO;
}

@end
