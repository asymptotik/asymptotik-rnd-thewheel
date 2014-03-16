//
//  AtkAnimationLoopNSTimer.m
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkAnimationLoop.h"
#import "AtkAnimationLoopNSTimer.h"
#import "AtkAnimationFrameData.h"


@implementation AtkAnimationLoopNSTimer

-(void)start
{
    if(!isRunning)
    {
        [super start];
        theFrameData = [[AtkAnimationFrameData alloc] initWithCurrentTime];
        theTimer = [NSTimer scheduledTimerWithTimeInterval:theInterval target: self selector: @selector(handleTimer:) userInfo: theFrameData repeats: YES];
    }
}

-(void)stop
{
    if(isRunning)
    {
        [super stop];
        [theTimer invalidate];
        [theFrameData release];
    }
}

-(void)handleTimer: (NSTimer *)aTimer
{
    [theFrameData update];
    [super handleUpdateWithFrameData: theFrameData];
}

- (void)dealloc
{
    NSLog(@"AtkAnimationLoop: dealloc");
    [super dealloc];
}


@end
