//
//  LVRedSquareView.h
//  AsyncCollectionsDemo
//
//  Created by Martín Fernández on 4/21/14.
//  Copyright (c) 2014 Loovin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <LVAsyncRender.h>

@interface LVRedSquareView : UIView <LVAsyncRender>

@property (nonatomic, copy) NSNumber *n;

@end
