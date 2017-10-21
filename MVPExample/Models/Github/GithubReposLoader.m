//
//  GithubReposLoader.m
//  MVPExample
//
//  Created by Kovalev_A on 21.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import "GithubReposLoader.h"

@interface GithubReposLoader ()

@property (nonatomic, copy) NSString *userName;

@end

@implementation GithubReposLoader

+ (instancetype)loaderWithLogin:(NSString *)login
{
    return [[self alloc] initWithLogin:login];
}

- (instancetype)initWithLogin:(NSString *)login
{
    if (self = [super init]) {
        self.userName = login;
    }
    return self;
}

- (NSURLRequest *)createRequest
{
    NSString *requestString = [NSString stringWithFormat:@"https://api.github.com/users/%@/repos", self.userName];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
}

- (void)requestItemsWithCompletion:(void (^)(NSString *, NSArray *))completion
{
    [self runRequest:[self createRequest] withCompletion:^(NSDictionary *resultDict, NSString *errorDescription) {
        NSLog(@"repos");
    }];
}

@end
