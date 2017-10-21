//
//  MBTableViewController.h
//  MVPExample
//
//  Created by Kovalev_A on 24.09.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemsPresenter;

@interface BlocksTableViewController : UITableViewController

@property (nonatomic, copy) NSInteger (^numberOfSectionsBlock)(NSArray *items);
@property (nonatomic, copy) NSInteger (^numberOfRowsBlock)(NSArray *items, NSInteger section);
@property (nonatomic, copy) id (^itemAtIndexPath)(NSArray *items, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^configureCellBlock)(id item, __kindof UITableViewCell *cell);
@property (nonatomic, copy) void (^didSelectBlock)(__kindof UIViewController *view, id item);
@property (nonatomic, strong) id<ItemsPresenter> presenter;

+ (instancetype)controllerWithPresenter:(id<ItemsPresenter>)presenter style:(UITableViewStyle)style cellId:(NSString *)cellId;
- (instancetype)initWithPresenter:(id<ItemsPresenter>)presenter style:(UITableViewStyle)style cellId:(NSString *)cellId;

@end
