//
//  AtkViewController.h
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AtkWheelView.h"
#import "AtkSelectorView.h"

@interface AtkViewController : UIViewController <MRAngleHandler> {

}

@property (retain) AtkWheelView *wheelView;
@property (retain) AtkSelectorView *selectorView;
@property (assign) BOOL isWheelShowing;
@property (retain) NSArray *selectionViews;

- (void)viewDidLoad;
- (IBAction) handleButtonEvent: (id) sender;

@end
