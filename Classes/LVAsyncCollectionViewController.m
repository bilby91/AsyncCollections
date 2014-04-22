//
//  LVAsyncCollectionViewController.m
//
//  Created by Martín Fernández on 4/21/14.
//
//

#import "LVAsyncCollectionViewController.h"

#import "LVAsyncRenderCollectionCell.h"


NSString * const kAsyncCollectionViewRenderCell = @"kAsyncCollectionViewRenderCell";


@interface LVAsyncCollectionViewController ()

@property (nonatomic, strong) NSMutableDictionary *renders;
@property (nonatomic, strong) NSMutableDictionary *renderOperations;
@property (nonatomic, strong) NSOperationQueue    *renderQueue;

@end

@implementation LVAsyncCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.renders          = [NSMutableDictionary dictionary];
    self.renderOperations = [NSMutableDictionary dictionary];
    self.renderQueue      = [[NSOperationQueue alloc] init];

    [self.collectionView registerClass:[LVAsyncRenderCollectionCell class] forCellWithReuseIdentifier:kAsyncCollectionViewRenderCell];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LVAsyncRenderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAsyncCollectionViewRenderCell forIndexPath:indexPath];
    
    [self handleCell:cell atIndexPath:indexPath futureCell:^UIView<LVAsyncRenderCell> *{
        return (LVAsyncRenderCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancelRenderIfNeededAtIndexPath:indexPath];
}

- (void)cancelRenderIfNeededAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemId = [self.delegate asyncCollectionController:self idForItemAtIndexPath:indexPath];
    NSOperation *renderOperation = [self.renderOperations objectForKey:itemId];
    if (renderOperation)
        [renderOperation cancel];
}

- (void)handleCell:(UIView<LVAsyncRenderCell>*)cell atIndexPath:(NSIndexPath *)indexPath futureCell:(UIView<LVAsyncRenderCell>*(^)(void))futureCellBlock
{
    NSString *itemId = [self.delegate asyncCollectionController:self idForItemAtIndexPath:indexPath];
    id<LVAsyncRender> render = [self.renders objectForKey:itemId];
    
    
    if ([render hasRendered]) {
        
        cell.renderBitmap.image = [render renderWithSize:cell.frame.size];
        
    } else {
        
        
        [self.delegate asyncCollectionController:self prepareRenderForItemAtIndexPath:indexPath withCompletion:^(id<LVAsyncRender> newRender) {
            
            NSBlockOperation *renderOperation = [NSBlockOperation blockOperationWithBlock:^{
                
                UIImage *bitmap = [newRender renderWithSize:cell.frame.size];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    UIView<LVAsyncRenderCell> *futureCell = futureCellBlock();
                    
                    [self.delegate asyncCollectionController:self willDisplayRender:futureCell atIndexPath:indexPath];
                    
                    futureCell.renderBitmap.image = bitmap;
                    [self.renders setObject:newRender forKey:itemId];
                    
                }];
            }];
            
            [self.renderOperations setObject:renderOperation forKey:itemId];
            [self.renderQueue addOperation:renderOperation];
        }];
    }
    
}


@end
