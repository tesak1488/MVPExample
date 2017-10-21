//
//  MBViewsFactory.m
//  MVPExample
//
//  Created by Kovalev_A on 13.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "BlocksTableViewController.h"
#import "CachedObjectsDecorator.h"
#import "DataBaseAccessObject.h"
#import "GitHubRepoCell.h"
#import "GithubRepository.h"
#import "ItemsPresenter.h"
#import "ModuleAssembly.h"
#import "PresentersFactory.h"
#import "SimpleItemsPresenter.h"
#import "TableViewUpdater.h"

@interface ModuleAssembly ()

@property (nonatomic, strong) PresentersFactory *presentersFactory;

@end

@implementation ModuleAssembly

- (PresentersFactory *)presentersFactory
{
    if (!_presentersFactory) {
        _presentersFactory = [PresentersFactory new];
    }
    return _presentersFactory;
}

- (UIViewController *)gitHubRepositoriesViewController
{
    BlocksTableViewController *controller = [BlocksTableViewController controllerWithPresenter:[self.presentersFactory gitHubReposPresenterForLogin:@"tesak1488"] style:UITableViewStyleGrouped cellId:NSStringFromClass([GitHubRepoCell class])];
    controller.title = NSLocalizedString(@"GitHub repositories", nil);
    controller.configureCellBlock = ^(GithubRepository *item, GitHubRepoCell *cell) {
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.descriptionString;
    };
    controller.didSelectBlock = ^(__kindof BlocksTableViewController *view, GithubRepository *item) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    };
    return controller;
}

@end
