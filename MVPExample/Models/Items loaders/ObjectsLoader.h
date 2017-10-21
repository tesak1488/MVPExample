//
//  ObjectsLoader.h
//  MVPExample
//
//  Created by Kovalev_A on 13.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObjectsLoader <NSObject>

- (void)requestItemsWithCompletion:(void(^)(NSString * errorDescription, NSArray *items))completion;

@end
