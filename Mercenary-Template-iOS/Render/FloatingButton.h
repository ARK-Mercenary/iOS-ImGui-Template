//
//  FloatingButton.h
//  Mercenary-Rewrite
//
//  Created by Li on 3/20/25.
//

#pragma once

#import <UIKit/UIKit.h>

@interface FloatingButton : UIButton

-(instancetype)initWithSizeAndLocation:(CGRect)size;

-(BOOL)isButtonToggled;

@end
