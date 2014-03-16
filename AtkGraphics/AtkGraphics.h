//
//  AtkGraphics.h
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

CG_INLINE int
MRCircularNext(int n, int max) 
{ 
    if(n + 1 < max) return n + 1; 
    else return 0; 
}

CG_INLINE int
MRCircularPrevious(int n, int max) 
{ 
    if(n > 0) return n - 1; 
    else return max - 1; 
}

@interface UIImage (AtkGraphics) 

+ (UIImage*)imageFromMainBundleFile:(NSString*)aFileName; // does not cache like imageNamed

@end
