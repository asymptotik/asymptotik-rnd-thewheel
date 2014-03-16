//
//  AtkAnimationLoopMainLoop.m
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkAnimationLoop.h"
#import "AtkAnimationLoopMainLoop.h"


@implementation AtkAnimationLoopMainLoop

- (AtkAnimationLoop *)init
{
    self = [super init];
    
    if( self != NULL )
    {
        theYieldTime = 0.004;
    }
    return self;
}

- (void) start
{
    if(!isRunning)
    {
        // Run the loop on the main thread
        [super start];
        theFrameData = [[AtkAnimationFrameData alloc] initWithCurrentTime];
        
        SEL selector = @selector(mainLoop);
        NSMethodSignature* sig = [[self class] instanceMethodSignatureForSelector:selector];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget: self];
        [invocation setSelector:selector];
        [invocation performSelectorOnMainThread:@selector(invokeWithTarget:) withObject:self waitUntilDone:NO];
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
    NSTimeInterval timeOfNextUpdate = theFrameData.elapsedTime + theInterval;
    
	while (isRunning) 
    {
		NSAutoreleasePool *loopPool = [NSAutoreleasePool new];
        
        NSTimeInterval elapsed = [theFrameData calcElapsedTime];
        NSTimeInterval timeTillNextUpdate = timeOfNextUpdate - elapsed;
        if(timeTillNextUpdate <= 0.0f)
        {
            [theFrameData update];
            [super handleUpdateWithFrameData: theFrameData];		
            timeOfNextUpdate = theFrameData.elapsedTime + theInterval;
            while( CFRunLoopRunInMode(kCFRunLoopDefaultMode, theYieldTime, FALSE) == kCFRunLoopRunHandledSource);
            
        }
        else
        {
            while( CFRunLoopRunInMode(kCFRunLoopDefaultMode, timeTillNextUpdate, FALSE) == kCFRunLoopRunHandledSource);
        }
        
		[loopPool release];
	}	
    
    [theFrameData release];
}

- (void)dealloc
{
    //NSLog(@"AtkAnimationLoopMainLoop: dealloc");
    [super dealloc];
}

@end
