//
//  FloatingButton.mm
//  Mercenary-Rewrite
//
//  Created by Li on 3/20/25.
//
// 

#import <UIKit/UIKit.h>

#import "FloatingButton.h"

@implementation FloatingButton

CGPoint location = CGPointMake(0, 0);
bool toggle = false;

- (instancetype)initWithSizeAndLocation:(CGRect)size {
    self = [super initWithFrame:size];
    if (self) 
    {
        // TODO:
        //* Add your own icon URL here

        static NSString* imageURL = @"https://drive.google.com/thumbnail?id=1FnG--or2g-yjbA8OfXAVD3NlxS8vr1wU";
        
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage* menuIconImage = [UIImage imageWithData:imageData];

        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = self.frame.size.width * 0.0f;
        [self setBackgroundImage:menuIconImage forState:UIControlStateNormal];

        UITapGestureRecognizer* tapIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ButtonTapped)];
        [self addGestureRecognizer:tapIcon];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    location = point;
    [[self superview] bringSubviewToFront:self];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];

    float deltaX = point.x - location.x;
    float deltaY = point.y - location.y;
    CGPoint newCenter = CGPointMake(self.center.x + deltaX, self.center.y + deltaY);

    float halfX = CGRectGetMidX(self.bounds);
    newCenter.x = MAX(halfX, newCenter.x);
    newCenter.x = MIN(self.superview.bounds.size.width - halfX, newCenter.x);

    float halfY = CGRectGetMidY(self.bounds);
    newCenter.y = MAX(halfY, newCenter.y);
    newCenter.y = MIN(self.superview.bounds.size.height - halfY, newCenter.y);

    self.center = newCenter;
}

-(void)ButtonTapped {
    toggle = !toggle;
}

-(BOOL)isButtonToggled {
    return toggle;
}

@end
