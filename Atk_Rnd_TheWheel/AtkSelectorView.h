//
//  AtkSelectorView.h
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AtkSelectorView : UIView

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, assign) CGFloat spacing;

- (void) addSelectorViews: (NSArray*)aViews;
- (void) moveSelection: (CGFloat)distance;

@end
