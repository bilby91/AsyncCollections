//
//  LVRedSquareView.m
//  AsyncCollectionsDemo
//
//  Created by Martín Fernández on 4/21/14.
//  Copyright (c) 2014 Loovin. All rights reserved.
//

#import "LVRedSquareView.h"

@implementation LVRedSquareView
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
    
    CGRect middleRect = CGRectMake(size.width / 2, size.height / 3, 20, 20);

    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
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
