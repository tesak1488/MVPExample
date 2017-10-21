//
//  MBItemLoadersFactory.h
//  MVPExample
//
//  Created by Kovalev_A on 16.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObjectsLoader;

@interface ItemLoadersFactory : NSObject

- (id<ObjectsLoader>)repositoriesLoaderForLogin:(NSString *)login;

@end
