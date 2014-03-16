//
//  AtkAnimationLoop.m
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkAnimationLoop.h"
#import "AtkAnimationLoopNSTimer.h"
#import "AtkAnimationLoopDisplayLink.h"
#import "AtkAnimationLoopMainLoop.h"
#import "AtkAnimationLoopThreaded.h"

@implementation AtkAnimationLoop

+ (AtkAnimationLoop *)animationLoopWithType:(AtkAnimationLoopType)type target:(id)aTarget selector:(SEL)aSelector
{
    AtkAnimationLoop *ret;

    switch (type) {
        case kAtkAnimationLoopTypeNSTimer:
            ret = [[AtkAnimationLoopNSTimer alloc] initWithTarget: aTarget selector: aSelector];
            break;
            
        case kAtkAnimationLoopTypeDisplayLink:
            ret = [[AtkAnimationLoopDisplayLink alloc] initWithTarget: aTarget selector: aSelector];
            break;
            
        case kAtkAnimationLoopTypeMainLoop:
            ret = [[AtkAnimationLoopMainLoop alloc] initWithTarget: aTarget selector: aSelector];
            break;
            
        case kAtkAnimationLoopTypeThreaded:
            ret = [[AtkAnimationLoopThreaded alloc] initWithTarget: aTarget selector: aSelector];
            break;
            
        default:
            ret = [[AtkAnimationLoopNSTimer alloc] initWithTarget: aTarget selector: aSelector];
            break;
    }

    return ret;
}

- (AtkAnimationLoop *)initWithTarget: (id)aTarget selector:(SEL)aSelector
{
    self = [self init];
    
    if( self != NULL )
    {
        [theTarget autorelease];
        theTarget = aTarget;
        [theTarget retain];
        
        theDangSelector = aSelector;
        
        theImpMethod = (TICK_IMP) [aTarget methodForSelector:theDangSelector];
        
        theInterval = 1.0/30.0; // 30 fps is our default.
    }
    return self;
}

-(void)start
{
    isRunning = true;
    // override me
}

-(void)stop
{
    isRunning = false;
    // override me
}

- (void)handleUpdateWithFrameData:(AtkAnimationFrameData *)aFrameData
{
    theImpMethod(theTarget, theDangSelector, aFrameData);
}

- (void)dealloc
{
    //NSLog(@"AtkAnimationLoop: dealloc");
    [theTarget release];
    [super dealloc];
}

@end
