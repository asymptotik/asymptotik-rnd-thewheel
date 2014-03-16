//
//  AtkAnimationLoopDisplayLink.h
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtkAnimationloop.h"

@interface AtkAnimationLoopDisplayLink : AtkAnimationLoop 
{
    CADisplayLink *theDisplayLink;
    AtkAnimationFrameData *theFrameData;    
}

@end
