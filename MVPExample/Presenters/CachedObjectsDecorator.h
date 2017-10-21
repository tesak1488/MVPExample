//
//  MBCachedObjectsDecorator.h
//  MVPExample
//
//  Created by Kovalev_A on 10.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "ItemsPresenter.h"

@class DataBaseAccessObject;

@interface CachedObjectsDecorator : NSObject <ItemsPresenter>

+ (instancetype)decoratorWithPresenter:(id<ItemsPresenter>)presenter storage:(DataBaseAccessObject *)storage viewUpdater:(id<NSFetchedResultsControllerDelegate>)viewUpdater;
- (instancetype)initWithPresenter:(id<ItemsPresenter>)presenter storage:(DataBaseAccessObject *)storage viewUpdater:(id<NSFetchedResultsControllerDelegate>)viewUpdater;

@end
