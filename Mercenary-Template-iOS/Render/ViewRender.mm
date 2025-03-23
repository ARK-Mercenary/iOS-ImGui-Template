//
//  ViewRender.mm
//  Mercenary-Rewrite
//
//  Created by Li on 3/20/25.
//

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#include <objc/runtime.h>
#include <string>

#include "../ImGui/imgui.h"
#include "../ImGui/imgui_internal.h"
#include "../ImGui/imgui_impl_metal.h"

#import "ViewRender.h"
#import "MetalView.h"
#import "FloatingButton.h"

static FloatingButton* s_FloatingButton = nil;
static bool bIsMoveMenu = false;

@interface ViewRender () <MTKViewDelegate>

@property (nonatomic, readonly) MTKView *mtkView;
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;

@end

@implementation ViewRender

-(instancetype)init 
{
    self = [super init];
    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];
    if (!self.device) {
        NSLog(@"Metal is not supported");
        abort();
    }
    ImGui::CreateContext();
    ImGui::StyleColorsDark();

    ImGuiIO& io = ImGui::GetIO();
    io.IniFilename = nullptr;

    // TODO:
    //* Add your own font files and global font variable here
    
    ImFontConfig config;
    config.FontDataOwnedByAtlas = false;

    io.Fonts->AddFontFromFileTTF("/System/Library/Fonts/LanguageSupport/PingFang.ttc", 14.f, &config, io.Fonts->GetGlyphRangesChineseFull());
    
    ImGui_ImplMetal_Init(_device);
    return self;
}

-(void)viewDidLoad 
{
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
}

-(MetalView *)mtkView 
{
    return (MetalView *)self.view;
}

-(void)loadView 
{
    ImGuiIO& io = ImGui::GetIO();
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat scale = [UIScreen mainScreen].scale;

    io.DisplaySize.x = rect.size.width;
    io.DisplaySize.y = rect.size.height;
    io.DisplayFramebufferScale = ImVec2(scale, scale);

    self.view = [[MetalView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)drawInMTKView:(MetalView *)view 
{
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];

    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor == nil) {
        [commandBuffer commit];
        return;
    }
    ImGui_ImplMetal_NewFrame(renderPassDescriptor);
    ImGui::NewFrame();

    BOOL on = [s_FloatingButton isButtonToggled];
    view.userInteractionEnabled = on;
    
    // TODO:
    //* Create your own class which allows you to run your entire tweak/menu
    //* based off of one function. Example: Mercenary::Initialize(on);

    if (on)
    {
        ImVec2 WindowSize = ImVec2(384, 256);
        ImGui::SetNextWindowSize(WindowSize, ImGuiCond_Once);

        ImGuiWindowFlags WindowFlags = ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize;
        WindowFlags |= bIsMoveMenu ? 0 : ImGuiWindowFlags_NoMove;
        
        ImGui::Begin("Mercenary Template ", nullptr, WindowFlags);

        ImGui::Checkbox("Move Menu", &bIsMoveMenu);

        ImGui::End();
    }

    ImGui::Render();
    ImDrawData* draw_data = ImGui::GetDrawData();

    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0f, 0.0f, 0.0f, 0.0f);
    id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);
    [renderEncoder endEncoding];

    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

-(void)mtkView:(MetalView*)view drawableSizeWillChange:(CGSize)size 
{
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = size.width;
    io.DisplaySize.y = size.height;
}

+(instancetype)mainView 
{
    static ViewRender* s_Mercenary = [[ViewRender alloc] init];
    return s_Mercenary;
}

-(void)initMenuWithButton 
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;

    //* Customize Size, and Location here
    s_FloatingButton = [[FloatingButton alloc] initWithSizeAndLocation:CGRectMake(30, 30, 60, 60)];
        
    [window addSubview:self.view];
    [window addSubview:s_FloatingButton];

    [window bringSubviewToFront:s_FloatingButton];
}

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event      { [self updateIOWithTouchEvent:event]; }
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event      { [self updateIOWithTouchEvent:event]; }
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  { [self updateIOWithTouchEvent:event]; }
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event      { [self updateIOWithTouchEvent:event]; }

@end

static void didFinishLaunching(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ViewRender mainView] initMenuWithButton];
    });
}

__attribute__((constructor))  static void initialize() {
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDrop);
}
