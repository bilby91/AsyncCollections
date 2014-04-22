//
//  LVAsyncCollectionViewController.h
//
//  Created by Martín Fernández on 4/21/14.
//
//

#import <UIKit/UIKit.h>

#import "LVAsyncRender.h"

@class LVAsyncCollectionViewController;

@protocol LVAsyncCollectionViewControllerDelegate <UICollectionViewDataSource>

- (NSString *)asyncCollectionController:(LVAsyncCollectionViewController *)asyncCollectionController
              idForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)asyncCollectionController:(LVAsyncCollectionViewController *)asyncCollectionController prepareRenderForItemAtIndexPath:(NSIndexPath *)indexPath
              withCompletion:(void (^)(id<LVAsyncRender> render))completion;

- (void)asyncCollectionController:(LVAsyncCollectionViewController *)asyncCollectionController
    willDisplayRender:(UIView<LVAsyncRenderCell> *)cell
                 atIndexPath:(NSIndexPath *)path;

@end

@interface LVAsyncCollectionViewController : UICollectionViewController

@property (nonatomic, weak) id<LVAsyncCollectionViewControllerDelegate> delegate;

@end
