//
// Created by Igor Vasilenko on 03/07/16.
// Copyright (c) 2016 Igor Vasilenko. All rights reserved.
//

#import <Nimbus/NimbusModels.h>
#import "FeedDataDisplayManager.h"
#import "FeedCellObject.h"

@interface FeedDataDisplayManager () <UITableViewDelegate>

@property (strong, nonatomic) NITableViewModel *tableViewModel;
@property (strong, nonatomic) NITableViewActions *tableViewActions;
@property (strong, nonatomic) NSArray *cellObjects;

@end

@implementation FeedDataDisplayManager

#pragma mark - DataDisplayManager protocol

- (id <UITableViewDataSource>)dataSourceForTableView:(UITableView *)tableView
{
    if (!self.tableViewModel) {
        self.tableViewModel = [self configureTableViewModel];
    }
    return self.tableViewModel;
}

- (id <UITableViewDelegate>)delegateForTableView:(UITableView *)tableView baseTableViewDelegate:(id <UITableViewDelegate>)baseTableViewDelegate
{
    if (!self.tableViewActions) {
        [self configureTableViewActions];
    }
    return [self.tableViewActions forwardingTo:self];
}

#pragma mark - Private

- (void)configureTableViewActions
{
    self.tableViewActions = [[NITableViewActions alloc] initWithTarget:self];

    NIActionBlock feedItemActionBlock = ^BOOL(id object, UIViewController *controller, NSIndexPath *indexPath) {
        return YES;
    };
    [self.tableViewActions attachToClass:[FeedCellObject class] tapBlock:feedItemActionBlock];
}

- (NITableViewModel *)configureTableViewModel
{
    NITableViewModel *tableViewModel = [[NITableViewModel alloc] initWithListArray:self.cellObjects
                                                                          delegate:(id)([NICellFactory class])];
    return tableViewModel;
}

@end