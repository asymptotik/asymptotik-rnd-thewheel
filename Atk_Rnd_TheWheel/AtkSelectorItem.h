//
//  AtkSelectorItem.h
//  Rnd_OnTapWheel
//
//  Created by Rick Boykin on 3/15/14.
//  Copyright (c) 2014 Mondo Robot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtkSelectorItem : NSObject

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGPoint max;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) NSString *name;

- (AtkSelectorItem *)initWithView:(UIView *)view;

@end
