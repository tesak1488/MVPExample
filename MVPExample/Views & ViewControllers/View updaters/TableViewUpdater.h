//
//  MBTableViewControllerUpdater.h
//  MVPExample
//
//  Created by Kovalev_A on 12.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TableViewUpdater : NSObject<NSFetchedResultsControllerDelegate>

+ (instancetype)updaterWithTableViewController:(UITableViewController *)tableViewController;
- (instancetype)initWithtableViewController:(UITableViewController *)tableViewController;

@end
