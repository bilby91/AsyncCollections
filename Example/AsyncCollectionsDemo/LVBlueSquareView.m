//
//  LVBlueSquareView.m
//  AsyncCollectionsDemo
//
//  Created by Martín Fernández on 4/21/14.
//  Copyright (c) 2014 Loovin. All rights reserved.
//

#import "LVBlueSquareView.h"

@implementation LVBlueSquareView
{
    UIImage *_render;
}

@synthesize n = _n;

- (UIImage *)renderWithSize:(CGSize)size
{
    if (_render != nil)
        return _render;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    CGRect middleRect = CGRectMake(size.width / 2, size.height / 2, size.width / 2, size.height / 2);
    
    [[UIColor blueColor] setFill];
    CGContextFillRect(context, middleRect);
    
    
    [[self.n stringValue] drawInRect:middleRect withAttributes:nil];
    
    _render = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _render;
}

- (BOOL)hasRendered
{
    return _render != nil;
}


@end
