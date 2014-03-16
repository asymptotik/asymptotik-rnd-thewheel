//
//  AtkAnimationFrameData.m
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <sys/time.h>
#import <Foundation/Foundation.h>
#import "AtkAnimationFrameData.h"

@implementation AtkAnimationFrameData

@synthesize startTime;
@synthesize elapsedTime;
@synthesize deltaTime;

- (AtkAnimationFrameData *)initWithCurrentTime
{
    self = [self init];
    if( self != NULL )
    {
        struct timeval now;
        
        if( gettimeofday( &now, NULL) != 0 ) 
        {
            NSLog(@"gettimeofday returned an error.");
        }
        
        // convert to NSTimeInterval
        startTime = now.tv_sec + now.tv_usec / 1000000.0;
    }
    return self;
}

- (AtkAnimationFrameData *)initWithStartTime: (NSTimeInterval)startSeconds
{
    self = [super init];
    if( self != NULL )
    {
        startTime = startSeconds;
    }
    return self;
}

- (void)update
{
    struct timeval now;
    
    if( gettimeofday( &now, NULL) != 0 ) 
    {
        NSLog(@"gettimeofday returned an error.");
    }
    
    // convert to NSTimeInterval
    NSTimeInterval elapsed = (now.tv_sec + now.tv_usec / 1000000.0) - startTime;
    deltaTime = elapsed - elapsedTime;
    elapsedTime = elapsed;
}

- (NSTimeInterval) calcElapsedTime
{
    struct timeval now;
    
    if( gettimeofday( &now, NULL) != 0 ) 
    {
        NSLog(@"gettimeofday returned an error.");
    }
    
    // convert to NSTimeInterval
    return (now.tv_sec + now.tv_usec / 1000000.0) - startTime;
}

- (void)dealloc
{
    [super dealloc];
}
@end
