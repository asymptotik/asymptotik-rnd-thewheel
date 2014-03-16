//
//  AtkAnimationFrameData.h
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtkAnimationFrameData : NSObject 
{
    NSTimeInterval startTime;
    NSTimeInterval elapsedTime;
    NSTimeInterval deltaTime;
}

@property (assign) NSTimeInterval startTime;
@property (assign) NSTimeInterval elapsedTime;
@property (assign) NSTimeInterval deltaTime;

- (AtkAnimationFrameData *)initWithCurrentTime;
- (AtkAnimationFrameData *)initWithStartTime: (NSTimeInterval)startSeconds;
- (void)update;
- (NSTimeInterval) calcElapsedTime; // does not update
- (void)dealloc;

@end
