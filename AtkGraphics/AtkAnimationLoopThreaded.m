//
//  AtkAnimationLoopThreaded.m
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkAnimationLoopThreaded.h"


@implementation AtkAnimationLoopThreaded

- (void) start
{
    if(!isRunning)
    {
        // Run the loop on the main thread
        [super start];
        theFrameData = [[AtkAnimationFrameData alloc] initWithCurrentTime];
        
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(mainLoop) object:nil];
        [thread start];
        [thread release];
    }
}

-(void)stop
{
    if(isRunning)
    {
        [super stop];
    }
}

-(void) mainLoop
{
    
    NSTimeInterval updateTime = theFrameData.elapsedTime + theInterval;
	while( isRunning && ![[NSThread currentThread] isCancelled] ) 
    {
        // the time of (absolute) the next update
        
        updateTime = updateTime - [theFrameData calcElapsedTime]; // re-use variable as the time till (delta) the next update.
        if(updateTime > 0.0)
            usleep(updateTime * 1000000.0);
        
        [theFrameData update];
        updateTime = theFrameData.elapsedTime + theInterval;
        [self performSelectorOnMainThread:@selector(handleUpdate) withObject:nil waitUntilDone:YES];
        
    }	
    
    if(isRunning)
    {
        // canceled, so stop.
        [self stop];
    }
    
    [theFrameData release];
}

-(void) handleUpdate
{
    //[theFrameData update];
    NSLog(@"theFrameData elapsed time: %f", theFrameData.elapsedTime);
    [super handleUpdateWithFrameData: theFrameData];
}

- (void)dealloc
{
    //NSLog(@"AtkAnimationLoopMainLoop: dealloc");
    [super dealloc];
}

@end
