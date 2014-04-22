//
//  LVAsyncRender.h
//
//  Created by Martín Fernández on 3/30/14.
//  Copyright (c) 2014 Loovin. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LVAsyncRender <NSObject>


- (BOOL)hasRendered;
- (UIImage *)renderWithSize:(CGSize)size;

@end


@protocol LVAsyncRenderCell <NSObject>

@property (nonatomic, strong) UIImageView *renderBitmap;

@end
