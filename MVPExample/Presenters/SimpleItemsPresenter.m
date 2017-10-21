//
//  SimpleItemsPresenter.m
//  MVPExample
//
//  Created by Kovalev_A on 25.09.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import "ObjectsLoader.h"
#import "SimpleItemsPresenter.h"

@interface SimpleItemsPresenter()

@property (nonatomic, copy) NSString *noItemsString;
@property (nonatomic, strong) id<ObjectsLoader> loader;
@property (nonatomic, copy, readwrite) NSArray *items;

@end

@implementation SimpleItemsPresenter

+ (instancetype)presenterWithLoader:(id<ObjectsLoader>)loader emptyItemsString:(NSString *)emptyItemsString
{
    return [[self alloc] initWithLoader:loader emptyItemsString:emptyItemsString];
}

- (instancetype)initWithLoader:(id<ObjectsLoader>)loader emptyItemsString:(NSString *)emptyItemsString
{
    NSParameterAssert(loader && emptyItemsString);
    self = [super init];
    if (self) {
        self.loader = loader;
        self.noItemsString = emptyItemsString;
    }
    return self;
}

- (void)requestItemsWithCompetion:(void (^)(BOOL))completion
{
    __weak typeof(self) welf = self;
    [self.loader requestItemsWithCompletion:^(NSString *errorDescription, NSArray *items) {
        welf.noItemsString = errorDescription ? : welf.noItemsString;
        welf.items = items;
        completion(items.count > 0);
    }];
}

@end
