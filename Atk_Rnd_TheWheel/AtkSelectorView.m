//
//  AtkSelectorView.m
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CALayer.h>
#import "AtkGraphics.h"
#import "AtkSelectorView.h"
#import "AtkSelectorItem.h"

@interface  AtkSelectorView()
{
    UIImageView * _overlayView;
    int           _currentItemIndex;
    CGPoint       _myCenter;
}
@end

@implementation AtkSelectorView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.clipsToBounds = TRUE;
    self.items = [[[NSMutableArray alloc] init] autorelease];
    
    _myCenter = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    _currentItemIndex = -1;
    
    UIImage* image = [UIImage imageFromMainBundleFile:@"bg_01.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    _overlayView = imageView;
    _spacing = 100.0;
    self.layer.cornerRadius = 12.0;
}

// Array of Views to use as the items.
- (void) addSelectorViews: (NSArray*)aViews
{
    for(AtkSelectorItem *item in _items)
        [item.view removeFromSuperview];
    
    [_items removeAllObjects];
    
    int n = 1;
    
    for(UIView* view in aViews)
    {
        AtkSelectorItem *selectorItem = [[AtkSelectorItem alloc] initWithView: view];
        selectorItem.name = [NSString stringWithFormat:@"SelectorItem: %d", n++];
        [_items addObject: selectorItem];
        [self addSubview: view];
        view.hidden = TRUE;
        
        [selectorItem release];
    }
    
    [self addSubview: _overlayView];
    
    if(_items.count > 0)
    {
        _currentItemIndex = 0;
        AtkSelectorItem* currentItem = (AtkSelectorItem *)[_items objectAtIndex: 0];
        CGPoint position = CGPointMake(_myCenter.x - currentItem.center.x, _myCenter.y - currentItem.center.y);
        currentItem.position = position;
        currentItem.view.hidden = FALSE;
    }
    else
    {
        _currentItemIndex = -1;
    }
    
    [self moveSelection:0.0];
}

- (BOOL)adjustSectionItem: (int)itemIndex withPosition: (CGPoint)aPosition
{
    AtkSelectorItem* currentItem = (AtkSelectorItem *)[_items objectAtIndex: itemIndex];
    UIView* currentView = currentItem.view;
    CGPoint currentPosition = currentItem.position;
    BOOL ret = TRUE;
    
    if(aPosition.x < currentPosition.x)
    {
        if(aPosition.x + currentView.bounds.size.width < 0.0)
        {
            currentView.hidden = TRUE;
            ret = false;
        }
        else
        {
            currentView.hidden = FALSE;
            currentItem.position = aPosition;
        }   
    }
    else if(aPosition.x > self.bounds.size.width)
    {
        currentView.hidden = TRUE;
        ret = false;
    }
    else
    {
        currentView.hidden = FALSE;
        currentItem.position = aPosition;
    }    
    
    return ret;
}

- (void) moveSelection: (CGFloat)distance
{
    //NSLog(@"move selection: %f", distance);
    
    if(_currentItemIndex != -1)
    {
        int itemIndex = _currentItemIndex;
        int closestIndex = _currentItemIndex;
        CGFloat closestDistance = MAXFLOAT;
        
        BOOL visible = true;
        BOOL goForward = true;
        BOOL goBackward = true;
        
        AtkSelectorItem *currentItem = (AtkSelectorItem *)[_items objectAtIndex: itemIndex];
        CGPoint currentPosition = currentItem.position;
        currentPosition.x += distance;
        currentPosition.y = _myCenter.y - currentItem.center.y;
        visible = [self adjustSectionItem: itemIndex withPosition:currentPosition];
    
        if(visible == false)
        {
            //NSLog(@"First Item not visible! %@", currentItem.name);
            
            if(distance < 0.0)
            {
                for(int n = MRCircularPrevious(itemIndex, _items.count); n != _currentItemIndex; n = MRCircularPrevious(n, _items.count))
                {
                    AtkSelectorItem *nextItem = (AtkSelectorItem *)[_items objectAtIndex: n];
                    if(nextItem.view.hidden == FALSE)
                    {
                        nextItem.view.hidden = true;
                        break;
                    }
                }
                
                goBackward = false;
                // find the next visible
                do {
                    itemIndex = MRCircularNext(itemIndex, _items.count);
                    if(itemIndex == _currentItemIndex)
                    {
                        goForward = false;
                    }
                    else
                    {
                        AtkSelectorItem *nextItem = (AtkSelectorItem *)[_items objectAtIndex: itemIndex];
                        currentPosition.x = currentPosition.x + currentItem.center.x + _spacing - nextItem.center.x;
                        currentPosition.y = _myCenter.y - nextItem.center.y;
                    }
                    
                    visible = [self adjustSectionItem: itemIndex withPosition: currentPosition];
                    if(visible == FALSE) goBackward = true;

                } while (goForward && visible == FALSE);
            }
            else
            {
                for(int n = MRCircularNext(itemIndex, _items.count); n != _currentItemIndex; n = MRCircularNext(n, _items.count))
                {
                    AtkSelectorItem *nextItem = (AtkSelectorItem *)[_items objectAtIndex: n];
                    if(nextItem.view.hidden == FALSE)
                    {
                        nextItem.view.hidden = true;
                        break;
                    }
                }
                
                goForward = false;
                // find the next visible
                do {
                    itemIndex = MRCircularPrevious(itemIndex, _items.count);
                    if(itemIndex == _currentItemIndex)
                    {
                        goBackward = false;
                    }
                    else
                    {
                        AtkSelectorItem *nextItem = (AtkSelectorItem *)[_items objectAtIndex: itemIndex];
                        currentPosition.x = currentPosition.x + currentItem.center.x - _spacing - nextItem.center.x;
                        currentPosition.y = _myCenter.y - nextItem.center.y;
                    }
                    
                    visible = [self adjustSectionItem: itemIndex withPosition: currentPosition];
                    if(visible == FALSE) goForward = true;
                    
                } while (goBackward && visible == FALSE);
            }
        }
        
        if(goForward || goBackward)
        {
            int moveItemIndex = itemIndex;
            AtkSelectorItem *moveItem = (AtkSelectorItem *)[_items objectAtIndex: moveItemIndex];
            currentPosition = moveItem.position;

            CGFloat distanceFromCenter = abs(_myCenter.x - (moveItem.position.x + moveItem.center.x));
            if(distanceFromCenter < closestDistance)
            {
                closestDistance = distanceFromCenter;
                closestIndex = moveItemIndex;
            }
            
            while(goForward)
            {
                //NSLog(@"moveItemIndex %d", moveItemIndex);
                moveItemIndex = MRCircularNext(moveItemIndex, _items.count);
                //NSLog(@"next moveItemIndex %d", moveItemIndex);
                
                if(moveItemIndex == _currentItemIndex)
                {
                    goForward = false;
                }
                else
                {    
                    AtkSelectorItem *nextItem = (AtkSelectorItem *)[_items objectAtIndex: moveItemIndex];
                    currentPosition.x = currentPosition.x + moveItem.center.x + _spacing - nextItem.center.x;
                    currentPosition.y = _myCenter.y - nextItem.center.y;
                    goForward = [self adjustSectionItem: moveItemIndex withPosition: currentPosition];
                    
                    if(goForward)
                    {
                        CGFloat distanceFromCenter = abs(_myCenter.x - (nextItem.position.x + nextItem.center.x));
                        //NSLog(@"forward: checking distance to: %@ distanceFromCenter: %f clostest: %f", nextItem.name, distanceFromCenter, closestDistance);
                        if(distanceFromCenter < closestDistance)
                        {
                            //NSLog(@"forward: setting distance to: %@ distanceFromCenter: %f clostest: %f", nextItem.name, distanceFromCenter, closestDistance);
                            closestDistance = distanceFromCenter;
                            closestIndex = moveItemIndex;
                        }
                        
                        moveItem = nextItem;
                    }
                }
            }
            
            moveItemIndex = itemIndex;
            moveItem = (AtkSelectorItem *)[_items objectAtIndex: moveItemIndex];
            currentPosition = moveItem.position;
            
            while(goBackward)
            {
                moveItemIndex = MRCircularPrevious(moveItemIndex, _items.count);
                if(moveItemIndex == _currentItemIndex)
                {
                    goBackward = false;
                }
                else
                {    
                    AtkSelectorItem *nextItem = (AtkSelectorItem *)[_items objectAtIndex: moveItemIndex];
                    currentPosition.x = currentPosition.x + moveItem.center.x - _spacing - nextItem.center.x;
                    currentPosition.y = _myCenter.y - nextItem.center.y;
                    goBackward = [self adjustSectionItem: moveItemIndex withPosition: currentPosition];
                    
                    if(goBackward)
                    {
                        CGFloat distanceFromCenter = abs(_myCenter.x - (nextItem.position.x + nextItem.center.x));
                        
                        //NSLog(@"backward: checking distance to: %@ distanceFromCenter: %f clostest: %f", nextItem.name, distanceFromCenter, closestDistance);
                        if(distanceFromCenter < closestDistance)
                        {
                            //NSLog(@"backward: setting distance to: %@ distanceFromCenter: %f clostest: %f", nextItem.name, distanceFromCenter, closestDistance);
                            closestDistance = distanceFromCenter;
                            closestIndex = moveItemIndex;
                        }
                        
                        moveItem = nextItem;
                    }
                }
            }
        }
        
        //NSLog(@"Closest Index: %d", closestIndex);
        _currentItemIndex = closestIndex;
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)dealloc
{
    [super dealloc];
}

@end
