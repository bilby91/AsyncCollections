//
//  LVAsyncTableViewController.h
//
//  Created by Martín Fernández on 4/21/14.
//
//

#import <UIKit/UIKit.h>

#import "LVAsyncRender.h"

@class LVAsyncTableViewController;

@protocol LVAsyncTableViewControllerDelegate <UITableViewDataSource>

- (NSString *)asyncTableController:(LVAsyncTableViewController *)asyncTableController
              idForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)asyncTableController:(LVAsyncTableViewController *)asyncTableController prepareRenderForItemAtIndexPath:(NSIndexPath *)indexPath
              withCompletion:(void (^)(id<LVAsyncRender> render))completion;

- (void)asyncTableController:(LVAsyncTableViewController *)asyncTableController
    willDisplayRenderForCell:(UIView<LVAsyncRenderCell> *)cell
                 atIndexPath:(NSIndexPath *)path;

@end

@interface LVAsyncTableViewController : UITableViewController

@property (nonatomic, weak) id<LVAsyncTableViewControllerDelegate> delegate;

@end
