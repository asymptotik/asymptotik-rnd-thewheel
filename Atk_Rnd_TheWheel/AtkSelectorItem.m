//
//  AtkSelectorItem.m
//  Rnd_OnTapWheel
//
//  Created by Rick Boykin on 3/15/14.
//  Copyright (c) 2014 Mondo Robot LLC. All rights reserved.
//

#import "AtkSelectorItem.h"

@implementation AtkSelectorItem

@synthesize position = _position;

- (AtkSelectorItem *)initWithView:(UIView *)aView
{
    self.view = aView;
    self.center = CGPointMake(_view.bounds.size.width / 2.0, _view.bounds.size.height / 2.0);
    self.position = CGPointMake(0.0, 0.0);
    self.max = CGPointMake(_view.bounds.size.width, _view.bounds.size.height);
    
    return self;
}

- (void) setPosition: (CGPoint)aPosition
{
    _position = aPosition;
    self.view.transform = CGAffineTransformMakeTranslation(aPosition.x, aPosition.y);
}

- (void)dealloc
{
    self.view = NULL;
    [super dealloc];
}

@end
