//
//  GithubReposLoader.h
//  MVPExample
//
//  Created by Kovalev_A on 21.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import "NetworkObject.h"
#import "ObjectsLoader.h"

@interface GithubReposLoader : NetworkObject <ObjectsLoader>

+ (instancetype)loaderWithLogin:(NSString *)login;
- (instancetype)initWithLogin:(NSString *)login;

@end
