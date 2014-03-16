//
//  AtkWheelView.h
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CALayer.h>
#import "AtkAnimationLoop.h"

@interface AtkWheelView : UIView 

@property (retain) id <MRAngleHandler> angleHandler;
@property (assign) CGFloat acceleration;

- (void) handleUpdate: (AtkAnimationFrameData *)frameData;
- (void) showWheel;
- (void) hideWheel;

@end
