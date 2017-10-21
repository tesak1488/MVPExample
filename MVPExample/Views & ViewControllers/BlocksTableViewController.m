//
//  MBTableViewController.m
//  MVPExample
//
//  Created by Kovalev_A on 24.09.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import "BlocksTableViewController.h"
#import "ItemsPresenter.h"
#import <macros_blocks.h>
#import "UIScrollView+EmptyDataSet.h"

CGFloat const kDefaultEstimateRowHeight = 50;

@interface BlocksTableViewController () <DZNEmptyDataSetSource>

@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic, copy) NSString *cellId;

@end

@implementation BlocksTableViewController

+ (instancetype)controllerWithPresenter:(id<ItemsPresenter>)presenter style:(UITableViewStyle)style cellId:(NSString *)cellId
{
    return [[self alloc] initWithPresenter:presenter style:style cellId:cellId];
}

- (instancetype)initWithPresenter:(id<ItemsPresenter>)presenter style:(UITableViewStyle)style cellId:(NSString *)cellId
{
    self = [self initWithStyle:style];
    if (self) {
        self.cellId = cellId;
        self.presenter = presenter;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addEditButtonIfNeeded];
    [self setupTavleView];
    [self requestItems];
}

- (void)addEditButtonIfNeeded
{
    if ([self.presenter respondsToSelector:@selector(removeItem:withCompletion:)]) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
}

- (void)requestItems
{
    __weak typeof(self) welf = self;
    self.loading = YES;
    [self.presenter requestItemsWithCompetion:^(BOOL success) {
        welf.loading = NO;
        if (success) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[welf numberOfSectionsInTableView:welf.tableView] - 1];
            [welf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [welf.tableView reloadEmptyDataSet];
    }];
}

- (void)setupTavleView
{
    self.tableView.estimatedRowHeight = kDefaultEstimateRowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.emptyDataSetSource = self;
    UINib *cellNib = [UINib nibWithNibName:self.cellId bundle:NSBundle.mainBundle];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:self.cellId];
}

- (id)defaultItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemAtIndexPath ? self.itemAtIndexPath(self.presenter.items, indexPath) : self.presenter.items[indexPath.row];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.numberOfSectionsBlock ? self.numberOfSectionsBlock(self.presenter.items) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberOfRowsBlock ? self.numberOfRowsBlock(self.presenter.items, section) : self.presenter.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    safe_block(self.configureCellBlock, [self defaultItemAtIndexPath:indexPath], cell);
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    safe_block(self.didSelectBlock, self, [self defaultItemAtIndexPath:indexPath]);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    [self.presenter removeItem:[self defaultItemAtIndexPath:indexPath] withCompletion:^(BOOL success) {
        if (success) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }];
}

#pragma mark DZNEmptyDataSetSource

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (!self.isLoading) {
        return nil;
    }
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.color = UIColor.darkGrayColor;
    [indicator startAnimating];
    return indicator;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    BOOL isLoading = self.isLoading;
    BOOL doItemsExist = self.presenter.items.count > 0;
    return isLoading || doItemsExist ? nil : [[NSAttributedString alloc] initWithString:self.presenter.noItemsString];
}

@end
