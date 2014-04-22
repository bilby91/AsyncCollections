//
//  LVBlueSquaresViewController.m
//  AsyncCollectionsDemo
//
//  Created by Martín Fernández on 4/21/14.
//  Copyright (c) 2014 Loovin. All rights reserved.
//

#import "LVBlueSquaresViewController.h"

#import "LVBlueSquareView.h"

@interface LVBlueSquaresViewController ()

@property (nonatomic, strong) NSArray *squares;

@end

@implementation LVBlueSquaresViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *mSquares = [NSMutableArray array];
    
    for (int i = 1; i<1000; i++) {
        [mSquares addObject:@(i)];
    }
    
    self.squares = [mSquares copy];
    
    
    self.delegate = self;
}

- (NSString *)title
{
    return @"AsyncCollectionViewController";
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.squares.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [super collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}

#pragma mark - LVAsyncCollectionViewControllerDelegate

- (NSString *)asyncCollectionController:(LVAsyncCollectionViewController *)asyncCollectionController idForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.squares objectAtIndex:indexPath.row] stringValue];
}

-(void)asyncCollectionController:(LVAsyncCollectionViewController *)asyncCollectionController prepareRenderForItemAtIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(id<LVAsyncRender>))completion
{
    LVBlueSquareView *bView = [[LVBlueSquareView alloc] init];
    bView.n = [self.squares objectAtIndex:indexPath.row];
    
    completion(bView);
}

- (void)asyncCollectionController:(LVAsyncCollectionViewController *)asyncCollectionController willDisplayRender:(UIView<LVAsyncRenderCell> *)cell atIndexPath:(NSIndexPath *)path
{
    cell.alpha = 1;
}


@end
