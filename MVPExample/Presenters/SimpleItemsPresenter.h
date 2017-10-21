//
//  SimpleItemsPresenter.h
//  MVPExample
//
//  Created by Kovalev_A on 25.09.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemsPresenter.h"

@protocol ObjectsLoader;

@interface SimpleItemsPresenter : NSObject <ItemsPresenter>

+ (instancetype)presenterWithLoader:(id<ObjectsLoader>)loader emptyItemsString:(NSString *)emptyItemsString;
- (instancetype)initWithLoader:(id<ObjectsLoader>)loader emptyItemsString:(NSString *)emptyItemsString;

@end
