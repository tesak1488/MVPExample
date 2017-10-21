//
//  MBItemsPresenter.h
//  MVPExample
//
//  Created by Kovalev_A on 09.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ItemsPresenter <NSObject>

@property (nonatomic, copy, readonly) NSArray *items;
@property (nonatomic, copy, readonly) NSString *noItemsString;
- (void)requestItemsWithCompetion:(void(^)(BOOL success))completion;
@optional
- (void)removeItem:(id)item withCompletion:(void(^)(BOOL success))completion;
- (void)changeItem:(id)item withCompletion:(void(^)(BOOL success))completion;

@end
