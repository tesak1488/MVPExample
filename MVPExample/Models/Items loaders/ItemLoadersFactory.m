//
//  MBItemLoadersFactory.m
//  MVPExample
//
//  Created by Kovalev_A on 16.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import "GithubReposLoader.h"
#import "ItemLoadersFactory.h"

@implementation ItemLoadersFactory

- (id<ObjectsLoader>)repositoriesLoaderForLogin:(NSString *)login
{
    return [GithubReposLoader loaderWithLogin:login];
}

@end
