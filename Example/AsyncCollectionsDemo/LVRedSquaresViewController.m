//
//  LVRedSquaresViewController.m
//  AsyncCollectionsDemo
//
//  Created by Martín Fernández on 4/21/14.
//  Copyright (c) 2014 Loovin. All rights reserved.
//

#import "LVRedSquaresViewController.h"

#import "LVRedSquareView.h"

@interface LVRedSquaresViewController ()

@property (nonatomic, strong) NSArray *squares;

@end

@implementation LVRedSquaresViewController

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
    return @"AsyncTabkeViewController";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.squares.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - LVAsyncCollectionViewControllerDelegate

- (NSString *)asyncTableController:(LVAsyncTableViewController *)asyncTableController idForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.squares objectAtIndex:indexPath.row] stringValue];
}

- (void)asyncTableController:(LVAsyncTableViewController *)asyncTableController prepareRenderForItemAtIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(id<LVAsyncRender>))completion
{
    LVRedSquareView *rView = [[LVRedSquareView alloc] init];
    rView.n = [self.squares objectAtIndex:indexPath.row];
    
    completion(rView);
}

- (void)asyncTableController:(LVAsyncTableViewController *)asyncTableController willDisplayRenderForCell:(UIView<LVAsyncRenderCell> *)cell atIndexPath:(NSIndexPath *)path
{
    cell.alpha = 1;
}

@end
