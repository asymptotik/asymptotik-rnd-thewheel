//
//  AtkGraphics.m
//  Atk
//
//  Created by Rick Boykin on 3/10/14.
//  Copyright 2014 Asymptotik Limited. All rights reserved.
//

#import "AtkGraphics.h"

@implementation UIImage (AtkGraphics)
+ (UIImage*)imageFromMainBundleFile:(NSString*)aFileName
{
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath,aFileName]];
}
@end
