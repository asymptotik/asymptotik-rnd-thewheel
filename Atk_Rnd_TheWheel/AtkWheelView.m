//
//  AtkWheelView.m
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAMediaTimingFunction.h>

#include <math.h>

#import "AtkWheelView.h"
#import "AtkGraphics.h"
#import "AtkAnimationLoopNSTimer.h"

@interface AtkWheelView()
{
    UIImageView *transformView;
    UITouch *trackedTouch;
    CGPoint centerPoint;
    NSTimeInterval previousMoveTimestamp;
    NSTimeInterval lastMoveTimestamp;
    CGFloat lastDeltaAngle;
    CGFloat theAngle;
    CGFloat currentVelocity; // Velocity for frame
    CGFloat previousATan; // keep around to prevent normalizing calc.
    AtkAnimationLoop *animationTimer;
}

- (void) spinWheel: (CGFloat)speed;
@end

@implementation AtkWheelView

@synthesize acceleration;
@synthesize angleHandler;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    // The transform view is what gets rotated.
    CGRect innerFrame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    transformView = [[UIImageView alloc] initWithFrame: innerFrame];
    [self addSubview: transformView];
    
    UIImage * uiImage = [UIImage imageFromMainBundleFile: @"wheel.png"];
    transformView.image = uiImage;
    transformView.userInteractionEnabled = NO;
    acceleration = 4.0;
    
    [uiImage release];
}

- (void) spinWheel: (CGFloat)velocity
{
    //NSLog(@"velocity %f", velocity);
    currentVelocity = velocity;
    animationTimer = [AtkAnimationLoop animationLoopWithType: kAtkAnimationLoopTypeMainLoop target: self selector: @selector(handleUpdate:)];
    [animationTimer start];
}

- (void) showWheel
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:-80.0],
                           [NSNumber numberWithFloat:-180.0],
                           [NSNumber numberWithFloat:-150.0],
                           [NSNumber numberWithFloat:-160.0], nil];
    theAnimation.duration = 0.4;
    theAnimation.removedOnCompletion = YES;
    
    [self.layer addAnimation:theAnimation forKey:@"bounce-in"];
    [self.layer setValue:[NSNumber numberWithInt:-160.0] forKeyPath:@"transform.translation.y"];
}

- (void) hideWheel
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:-160.0],
                           [NSNumber numberWithFloat:-180.0],
                           [NSNumber numberWithFloat:0.0], nil];
    theAnimation.duration = 0.25;
    theAnimation.removedOnCompletion = YES;

    [self.layer addAnimation:theAnimation forKey:@"bounce-out"];
    [self.layer setValue:[NSNumber numberWithInt:0.0] forKeyPath:@"transform.translation.y"];
}

// 
// Event Handling
//

- (void)handleUpdate: (AtkAnimationFrameData *)frameData
{
    CGFloat angle = (currentVelocity * frameData.deltaTime) + (0.5 * (currentVelocity < 0.0 ? acceleration : -acceleration) * frameData.deltaTime * frameData.deltaTime);
    CGFloat newVelocity = angle / frameData.deltaTime;

    if(newVelocity == 0.0 || (currentVelocity < 0.0 && newVelocity > 0.0) || (currentVelocity > 0.0 && newVelocity < 0.0))
    {
        
        [animationTimer stop];
        [animationTimer release];
        animationTimer = NULL;
    }
    else
    {
        currentVelocity = newVelocity;
        CGFloat rotation = theAngle + angle;
        
        if(rotation > 360) rotation -= 360;
        else if(rotation < -360) rotation += 360;
        
        CGAffineTransform transform = transformView.transform;
        transform = CGAffineTransformMakeRotation(rotation);
        transformView.transform = transform; 
        
        if(angleHandler != NULL)
            [angleHandler handleAngleChanged:theAngle delta:angle time: frameData.deltaTime];
        
        theAngle = rotation;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) 
    {
        if (touch.tapCount == 1) 
        {
            if(animationTimer != NULL)
            {
                [animationTimer stop];
                [animationTimer release];
                animationTimer = NULL;
            }
            
            CGRect theBounds = transformView.bounds;
            trackedTouch = touch;
            centerPoint = CGPointMake(self.layer.anchorPoint.x * theBounds.size.width, self.layer.anchorPoint.y * theBounds.size.height);
            previousMoveTimestamp = 0.0;
            lastMoveTimestamp = touch.timestamp;
            
            // Vectorize and normalize only if this is the first call to move after touch starts
            CGPoint touchPoint = [touch locationInView:self];
            CGPoint vector = CGPointMake(touchPoint.x - centerPoint.x, touchPoint.y - centerPoint.y);
            
            CGFloat previousMag = sqrt(vector.x * vector.x + vector.y * vector.y);
            vector.x = vector.x / previousMag;
            vector.y = vector.y / previousMag;
            previousATan = atan2(vector.y, vector.x);
        }
    }    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) 
    {
        if (touch == trackedTouch) 
        {                        
            // Vectorize and normalize
            CGPoint currentTouchPoint = [touch locationInView:self];
            CGPoint currentVector = CGPointMake(currentTouchPoint.x - centerPoint.x, currentTouchPoint.y - centerPoint.y);
            
            CGFloat currentMag = sqrt(currentVector.x * currentVector.x + currentVector.y * currentVector.y);
            currentVector.x = currentVector.x / currentMag;
            currentVector.y = currentVector.y / currentMag;
            CGFloat currentATan = atan2(currentVector.y, currentVector.x);
           
            CGFloat a = currentATan - previousATan;
            
            CGFloat rotation = theAngle + a;
            
            if(rotation > 360) rotation -= 360;
            else if(rotation < -360) rotation += 360;
            
            CGAffineTransform transform = transformView.transform;
            transform = CGAffineTransformMakeRotation(rotation);
            transformView.transform = transform;
                 
            previousMoveTimestamp = lastMoveTimestamp;
            lastMoveTimestamp = touch.timestamp;
            lastDeltaAngle = a;
            
            previousATan = currentATan;
            
            if(angleHandler != NULL)
                [angleHandler handleAngleChanged:theAngle delta:a time: (lastMoveTimestamp - previousMoveTimestamp)];
                 
            theAngle = rotation;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) 
    {
        if (touch == trackedTouch) 
        {
            CGFloat velocity = lastDeltaAngle / (lastMoveTimestamp - previousMoveTimestamp);
            
            if(velocity < -5.0)
                velocity = -5.0;
            else if(velocity > 5.0)
                velocity = 5.0;

            [self spinWheel: velocity];
        }
    }
    
    trackedTouch = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    trackedTouch = nil;
}

- (void)dealloc
{
    self.angleHandler = NULL;
    [super dealloc];
}

@end
