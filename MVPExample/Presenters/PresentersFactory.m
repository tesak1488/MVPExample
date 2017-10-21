//
//  PresentersFactory.m
//  MVPExample
//
//  Created by Kovalev_A on 21.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import "ItemLoadersFactory.h"
#import "PresentersFactory.h"
#import "SimpleItemsPresenter.h"

@interface PresentersFactory ()

@property (nonatomic, strong) ItemLoadersFactory *loadersFactory;

@end

@implementation PresentersFactory

- (ItemLoadersFactory *)loadersFactory
{
    if (!_loadersFactory) {
        _loadersFactory = [ItemLoadersFactory new];
    }
    return _loadersFactory;
}

- (id<ItemsPresenter>)gitHubReposPresenterForLogin:(NSString *)login
{
    return [SimpleItemsPresenter presenterWithLoader:[self.loadersFactory repositoriesLoaderForLogin:login] emptyItemsString:NSLocalizedString(@"There are no repositories", nil)];
}

@end
