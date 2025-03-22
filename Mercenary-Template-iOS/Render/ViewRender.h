//
//  ViewRender.h
//  Mercenary-Rewrite
//
//  Created by Li on 3/20/25.
//

#pragma once

@interface ViewRender : UIViewController

+ (instancetype)mainView;
- (void)initMenuWithButton;
- (void)updateIOWithTouchEvent:(UIEvent *)event;

@end
