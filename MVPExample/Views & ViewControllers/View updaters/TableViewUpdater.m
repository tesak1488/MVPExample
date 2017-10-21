//
//  MBTableViewControllerUpdater.m
//  MVPExample
//
//  Created by Kovalev_A on 12.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import "TableViewUpdater.h"

@interface TableViewUpdater ()

@property (nonatomic, weak) UITableViewController *controller;

@end

@implementation TableViewUpdater

+ (instancetype)updaterWithTableViewController:(UITableViewController *)tableViewController
{
    return [[self alloc] initWithtableViewController:tableViewController];
}

- (instancetype)initWithtableViewController:(UITableViewController *)tableViewController
{
    NSParameterAssert(tableViewController);
    if (self) {
        self.controller = tableViewController;
    }
    return self;
}

- (UITableView *)updatingTableView
{
    return self.controller.tableView;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (NSThread.isMainThread) {
        [[self updatingTableView] beginUpdates];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self controllerWillChangeContent:controller];
        });
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if (NSThread.isMainThread) {
        UITableView *tableView = [self updatingTableView];
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeUpdate:
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeMove:
                break;
        }
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self controller:controller didChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
        });
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    if (NSThread.isMainThread) {
        UITableView *tableView = [self updatingTableView];
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;
        }
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
        });
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (NSThread.isMainThread) {
        [[self updatingTableView] endUpdates];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self controllerDidChangeContent:controller];
        });
    }
}

@end
