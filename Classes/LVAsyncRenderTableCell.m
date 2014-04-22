//
//  LVAsyncRenderTableCell.m
//
//  Created by Martín Fernández on 3/30/14.
//  Copyright (c) 2014 Loovin. All rights reserved.
//

#import "LVAsyncRenderTableCell.h"

@implementation LVAsyncRenderTableCell

@synthesize renderBitmap;

- (id)init
{
    self = [super init];
    
    if(self) {
        [self setup];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
    }
    
    return self;
}


- (void)setup
{
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize    = YES;
    self.opaque                   = YES;
    self.renderBitmap             = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.contentScaleFactor       = [[UIScreen mainScreen] scale];
    [self addSubview:self.renderBitmap];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.renderBitmap.image = nil;
    self.renderBitmap.alpha = 1.f;
}

@end
