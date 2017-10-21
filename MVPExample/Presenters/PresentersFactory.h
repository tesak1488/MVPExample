//
//  PresentersFactory.h
//  MVPExample
//
//  Created by Kovalev_A on 21.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ItemsPresenter;

@interface PresentersFactory : NSObject

- (id<ItemsPresenter>)gitHubReposPresenterForLogin:(NSString *)login;

@end
