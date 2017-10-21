//
//  MBCachedObjectsDecorator.m
//  MVPExample
//
//  Created by Kovalev_A on 10.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import "CachedObjectsDecorator.h"
#import "DataBaseAccessObject.h"
#import <macros_blocks.h>

@interface CachedObjectsDecorator ()

@property (nonatomic, strong) id<ItemsPresenter> presenter;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) id<NSFetchedResultsControllerDelegate> viewUpdater;
@property (nonatomic, strong) DataBaseAccessObject *storage;

@end

@implementation CachedObjectsDecorator

+ (instancetype)decoratorWithPresenter:(id<ItemsPresenter>)presenter storage:(DataBaseAccessObject *)storage viewUpdater:(id<NSFetchedResultsControllerDelegate>)viewUpdater
{
    return [[self alloc] initWithPresenter:presenter storage:storage viewUpdater:viewUpdater];
}

- (instancetype)initWithPresenter:(id<ItemsPresenter>)presenter storage:(DataBaseAccessObject *)storage viewUpdater:(id<NSFetchedResultsControllerDelegate>)viewUpdater
{
    NSParameterAssert(presenter && storage && viewUpdater);
    self = [self init];
    if (self) {
        self.presenter = presenter;
        self.storage = storage;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[storage fetchRequest] managedObjectContext:storage.context sectionNameKeyPath:nil cacheName:nil];
        self.viewUpdater = viewUpdater;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(contextDidSaveWithNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
        [self.fetchedResultsController performFetch:nil];
    }
    return self;
}

- (void)contextDidSaveWithNotification:(NSNotification *)notification
{
    if (notification.object != self.fetchedResultsController.managedObjectContext) {
        return;
    }
     NSError *error;
     NSAssert([self.fetchedResultsController performFetch:&error], error.localizedDescription);
}

- (void)setViewUpdater:(id<NSFetchedResultsControllerDelegate>)viewUpdater
{
    _viewUpdater = viewUpdater;
    self.fetchedResultsController.delegate = viewUpdater;
}

- (NSString *)noItemsString
{
    return self.presenter.noItemsString;
}

- (NSArray *)items
{
    return self.fetchedResultsController.fetchedObjects;
}

- (void)removeItem:(id)item withCompletion:(void (^)(BOOL))completion
{
    [self.storage removeObject:item];
}

- (void)changeItem:(id)item withCompletion:(void (^)(BOOL))completion
{
    [self.storage changeObject:item];
}

- (void)requestItemsWithCompetion:(void (^)(BOOL))completion
{
    __weak typeof(self) welf = self;
    [self.presenter requestItemsWithCompetion:^(BOOL success) {
        [welf.storage insertObjects:welf.presenter.items];
        safe_block(completion, NO);
    }];
}

@end
