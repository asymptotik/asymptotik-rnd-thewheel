//
//  AtkAnimationLoopNSTimer.h
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtkAnimationLoop.h"
#import "AtkAnimationFrameData.h"

@interface AtkAnimationLoopNSTimer : AtkAnimationLoop
 {
    
    NSTimer *theTimer;
    AtkAnimationFrameData *theFrameData;
}

-(void)handleTimer: (NSTimer *)aTimer;

@end
