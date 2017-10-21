//
//  NetworkObject.h
//  MVPExample
//
//  Created by Kovalev_A on 21.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkObject : NSObject

- (void)runRequest:(NSURLRequest *)request withCompletion:(void (^)(NSDictionary *resultDict, NSString *errorDescription))completion;

@end
