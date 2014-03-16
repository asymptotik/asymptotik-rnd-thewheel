//
//  AtkAnimationLoopDisplayLink.m
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "AtkAnimationLoopDisplayLink.h"


@implementation AtkAnimationLoopDisplayLink

- (void)start
{
    if(!isRunning)
    {
        [super start];
        theFrameData = [[AtkAnimationFrameData alloc] initWithCurrentTime];
        
        // approximate frame rate
        // assumes device refreshes at 60 fps
        int animationFrameInterval = (int) floor(theInterval * 60.0f);
        
        CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(handleTimer:)];
        [aDisplayLink setFrameInterval:animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        theDisplayLink = aDisplayLink;
    }
}

-(void) stop
{
    if(isRunning)
    {
        [super stop];
        [theDisplayLink invalidate];
        [theFrameData release];
    }
}

-(void)handleTimer:(CADisplayLink *)sender
{
    [theFrameData update];
    [super handleUpdateWithFrameData: theFrameData];
}

- (void)dealloc
{
    //NSLog(@"AtkAnimationLoopMainLoop: dealloc");
    [super dealloc];
}

@end
