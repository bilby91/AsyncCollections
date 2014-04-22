//
//  LVAsyncTableViewController.m
//
//  Created by Martín Fernández on 4/21/14.
//
//

#import "LVAsyncTableViewController.h"

#import "LVAsyncRenderTableCell.h"

NSString * const kAsyncTableViewRenderCell = @"kAsyncTableViewRenderCell";

@interface LVAsyncTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *renders;
@property (nonatomic, strong) NSMutableDictionary *renderOperations;
@property (nonatomic, strong) NSOperationQueue    *renderQueue;

@end

@implementation LVAsyncTableViewController

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.renders          = [NSMutableDictionary dictionary];
    self.renderOperations = [NSMutableDictionary dictionary];
    self.renderQueue      = [[NSOperationQueue alloc] init];
    
    [self.tableView registerClass:[LVAsyncRenderTableCell class] forCellReuseIdentifier:kAsyncTableViewRenderCell];


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LVAsyncRenderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kAsyncTableViewRenderCell forIndexPath:indexPath];
    
    [self handleCell:cell atIndexPath:indexPath futureCell:^UIView<LVAsyncRenderCell> *{
        return (LVAsyncRenderTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancelRenderIfNeededAtIndexPath:indexPath];
}

- (void)cancelRenderIfNeededAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemId = [self.delegate asyncTableController:self idForItemAtIndexPath:indexPath];
    NSOperation *renderOperation = [self.renderOperations objectForKey:itemId];
    if (renderOperation)
        [renderOperation cancel];
}

- (void)handleCell:(UIView<LVAsyncRenderCell>*)cell atIndexPath:(NSIndexPath *)indexPath futureCell:(UIView<LVAsyncRenderCell>*(^)(void))futureCellBlock
{
    NSString *itemId = [self.delegate asyncTableController:self idForItemAtIndexPath:indexPath];
    id<LVAsyncRender> render = [self.renders objectForKey:itemId];
    
    
    if ([render hasRendered]) {
        
        cell.renderBitmap.image = [render renderWithSize:cell.frame.size];
        
    } else {
        
        
        [self.delegate asyncTableController:self prepareRenderForItemAtIndexPath:indexPath withCompletion:^(id<LVAsyncRender> newRender) {
            
            NSBlockOperation *renderOperation = [NSBlockOperation blockOperationWithBlock:^{
                
                UIImage *bitmap = [newRender renderWithSize:cell.frame.size];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    UIView<LVAsyncRenderCell> *futureCell = futureCellBlock();
                    
                    [self.delegate asyncTableController:self willDisplayRenderForCell:futureCell atIndexPath:indexPath];
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
