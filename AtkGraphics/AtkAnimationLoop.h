//
//  AtkAnimationLoop.h
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtkAnimationLoop.h"
#import "AtkAnimationFrameData.h"

typedef void (*TICK_IMP)(id, SEL, AtkAnimationFrameData *);

@protocol MRAngleHandler

- (void) handleAngleChanged:(CGFloat)angle delta:(CGFloat)angleDelta time:(CGFloat)timeDelta;

@end

typedef enum 
{
	/** Will use an AtkAnimationLoop that triggers the main loop from an NSTimer object
	 *
	 * Features and Limitations:
	 * - Integrates OK with UIKit objects
	 * - It the slowest AtkAnimationLoop
	 * - The invertal update is customizable up to 1/60
     * - The NSMainLoop resets the time to an additional interval if control is not 
     *   received back to the NSMailLoop (and the NSTimer check) before the next interval starts.
	 */
	kAtkAnimationLoopTypeNSTimer,
	/** Will use a AtkAnimationLoop that synchronizes timers with the refresh rate of the display.
	 *
	 * Features and Limitations:
	 * - Faster than NSTimer AtkAnimationLoop
	 * - Only available on 3.1+
	 * - Scheduled timers & drawing are synchronizes with the refresh rate of the display
	 * - Integrates OK with UIKit objects
	 * - The interval update can be 1/60, 1/30, 1/15
	 */	
    kAtkAnimationLoopTypeDisplayLink,
    /** will use a AtkAnimationLoop that triggers the main loop from a custom main loop.
	 *
	 * Features and Limitations:
	 * - Faster than NSTimer AtkAnimationLoop especially when rendering time exceeds interval
	 * - It doesn't integrate well with UIKit objecgts
	 * - The interval update can't be customizable
	 */
    kAtkAnimationLoopTypeMainLoop,
    /** Will use a AtkAnimationLoop that triggers the updates from a thread, but the updates will be executed on the main thread.
	 *
	 * Features and Limitations:
	 * - Faster than NSTimer AtkAnimationLoop
	 * - It doesn't integrate well with UIKit objecgts
	 * - The interval update can't be customizable
	 */
    kAtkAnimationLoopTypeThreaded
    
} AtkAnimationLoopType;
    
@interface AtkAnimationLoop : NSObject 
{
    NSTimeInterval theInterval; // seconds
    TICK_IMP theImpMethod;
    id theTarget;
    SEL theDangSelector;
    BOOL isRunning;
}

+ (AtkAnimationLoop *)animationLoopWithType:(AtkAnimationLoopType)type target:(id)aTarget selector:(SEL)aSelector;

- (AtkAnimationLoop *)initWithTarget: (id)aTarget selector:(SEL)aSelector;
- (void)start;
- (void)stop;
- (void)dealloc;
- (void)handleUpdateWithFrameData: (AtkAnimationFrameData *)aFrameData;

@end
