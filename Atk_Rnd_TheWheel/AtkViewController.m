//
//  AtkViewController.m
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CALayer.h>

#import "AtkGraphics.h"
#import "AtkViewController.h"
#import "AtkWheelView.h"

@implementation AtkViewController

@synthesize selectorView;
@synthesize wheelView;
@synthesize isWheelShowing;
@synthesize selectionViews;

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    //do stuff with my data
    AtkWheelView *newAtkWheelView = [[AtkWheelView alloc] initWithFrame: CGRectMake(0.0, self.view.frame.size.height, 320.0, 320.0)];
    [newAtkWheelView autorelease];
    self.wheelView = newAtkWheelView;
    [self.view addSubview: wheelView];
    
    AtkSelectorView *newAtkSelectorView = [[AtkSelectorView alloc] initWithFrame: CGRectMake(85.0, 75.0, 150.0, 150.0)];
    [newAtkSelectorView autorelease];
    self.selectorView = newAtkSelectorView;
    [self.view addSubview: newAtkSelectorView];
    
    NSMutableArray *theViews = [[NSMutableArray alloc] init];
    
    UIImage *image = [UIImage imageFromMainBundleFile: @"item_01.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];
    
    image = [UIImage imageFromMainBundleFile:@"item_02.png"];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];

    image = [UIImage imageFromMainBundleFile:@"item_03.png"];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];
    
    image = [UIImage imageFromMainBundleFile:@"item_04.png"];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];
    
    image = [UIImage imageFromMainBundleFile:@"item_05.png"];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];
    
    image = [UIImage imageFromMainBundleFile:@"item_06.png"];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];
    
    image = [UIImage imageFromMainBundleFile:@"item_07.png"];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];
    
    image = [UIImage imageFromMainBundleFile:@"item_08.png"];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];
    
    image = [UIImage imageFromMainBundleFile:@"item_09.png"];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];
    
    image = [UIImage imageFromMainBundleFile:@"item_10.png"];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];
    
    image = [UIImage imageFromMainBundleFile:@"item_11.png"];
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    [theViews addObject: imageView];
    [imageView release];
    
    [newAtkSelectorView addSelectorViews: theViews];
    [theViews release];
    
    newAtkWheelView.angleHandler = self;    
}

// Private methods not defined in interface
- (void) showWheel
{
    NSLog(@"show wheel!");
    
    [wheelView showWheel];
}

- (void) hideWheel
{
    NSLog(@"hide wheel!");
    
    [wheelView hideWheel];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) handleButtonEvent: (id) sender
{
    [self setIsWheelShowing:!isWheelShowing];
}

- (BOOL) isWheelShowing
{
    return isWheelShowing;
}

- (void) setIsWheelShowing: (BOOL)value
{
    NSLog(@"setIsWheelShowing! %d", value);
    if(isWheelShowing != value)
    {
        isWheelShowing = value;
        
        if(isWheelShowing)
        {
            [self showWheel];
        }
        else
        {
            [ self hideWheel];
        }
    }
}

- (void) handleAngleChanged:(CGFloat)angle delta:(CGFloat)angleDelta time:(CGFloat)timeDelta
{
    CGFloat distance = (wheelView.frame.origin.y + (wheelView.frame.size.height / 2.0)) - (selectorView.frame.origin.y + (selectorView.frame.size.height / 2.0));
    [selectorView moveSelection: distance * angleDelta];
}

- (void)dealloc
{
    self.wheelView = NULL;
    self.selectorView = NULL;
    [super dealloc];
}

@end
