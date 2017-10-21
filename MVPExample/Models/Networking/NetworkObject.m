//
//  NetworkObject.m
//  MVPExample
//
//  Created by Kovalev_A on 21.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import "NetworkObject.h"

@interface NetworkObject ()

@property (nonatomic, copy) void (^completion)(NSDictionary *dict, NSString *errorDesc);

@end

@implementation NetworkObject

- (void)runRequest:(NSURLRequest *)request withCompletion:(void (^)(NSDictionary *, NSString *))completion
{
    NSParameterAssert(completion);
    self.completion = completion;
    __weak typeof(self) welf = self;
    [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            welf.completion(nil, error.localizedDescription);
        } else {
            [welf parseData:data];
        }
    }] resume];
}

- (void)parseData:(NSData *)data
{
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        self.completion(nil, error.localizedDescription);
    } else {
        self.completion(dict, nil);
    }
}

@end
