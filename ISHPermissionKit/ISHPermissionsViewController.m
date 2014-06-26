//
//  ISHPermissionsViewController.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionsViewController.h"
#import "ISHPermissionRequest+All.h"
#import "ISHPermissionRequestViewController+Private.h"

@interface ISHPermissionsViewController () <ISHPermissionRequestViewControllerDelegate>
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSArray *permissionCategories;
@property (nonatomic) ISHPermissionRequestViewController *currentViewController;
@end

@implementation ISHPermissionsViewController

+ (instancetype)permissionsViewControllerWithCategories:(NSArray *)categories {
    NSArray *requestableCategories = [self requestablePermissionsCategoriesFromArray:categories];
    if (!requestableCategories.count) {
        return nil;
    }
    
    ISHPermissionsViewController *vc = [ISHPermissionsViewController new];
    [vc setPermissionCategories:requestableCategories];
    return vc;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setCurrentIndex:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self transitionToPermissionCategoryAtIndex:self.currentIndex];
}

- (void)transitionToPermissionCategoryAtIndex:(NSUInteger)index {
    NSAssert(index < self.permissionCategories.count, @"Transition must lead to an index within bounds");
    
    ISHPermissionCategory category = [self categoryAtIndex:index];
    ISHPermissionRequestViewController *newVC = [self.dataSource permissionsViewController:self requestViewControllerForCategory:category];
    NSAssert(newVC, @"Datasource should return an instance of ISHPermissionRequestViewController in -permissionsViewController:requestViewControllerForCategory:");
    
    [newVC setPermissionDelegate:self];
    [newVC setPermissionCategory:category];
    
    [self transitionFromViewController:self.currentViewController toViewController:newVC];
}

- (ISHPermissionCategory)categoryAtIndex:(NSUInteger)index {
    return [[self.permissionCategories objectAtIndex:index] integerValue];
}

+ (NSArray *)requestablePermissionsCategoriesFromArray:(NSArray *)neededCategories {
    NSMutableArray *requestable = [NSMutableArray arrayWithCapacity:neededCategories.count];
    
    for (NSNumber *categoryObj in neededCategories) {
        ISHPermissionCategory category = [categoryObj integerValue];
        ISHPermissionRequest *request = [ISHPermissionRequest requestForCategory:category];
        ISHPermissionState state = [request permissionState];
        
        switch (state) {
            case ISHPermissionStateUnknown:
            case ISHPermissionStateNeverAsked:
            case ISHPermissionStateAskAgain:
                [requestable addObject:categoryObj];
                break;
            default:
                break;
        }
    }
    
    return [requestable copy];
}

#pragma mark - ISHPermissionRequestViewControllerDelegate
- (void)permissionRequestViewController:(ISHPermissionRequestViewController *)vc didCompleteWithState:(ISHPermissionState)state {
    NSUInteger nextIndex = self.currentIndex + 1;
    if (nextIndex == self.permissionCategories.count) {
        [self.delegate permissionsViewControllerDidComplete:self];
        if (!self.delegate) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self transitionToPermissionCategoryAtIndex:nextIndex];
        [self setCurrentIndex:self.currentIndex + 1];
    }
}


#pragma mark -
#pragma mark - UIViewController Containment

- (void)transitionFromViewController:(ISHPermissionRequestViewController *)fromViewController toViewController:(ISHPermissionRequestViewController *)toViewController  {
    [self beginTransitionFromViewController:fromViewController toViewController:toViewController];
    
    if (fromViewController) {
        [self transitionFromViewController:fromViewController
                          toViewController:toViewController
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:NULL
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        [self completedTransitionFromViewController:fromViewController toViewController:toViewController];
                                    }
                                }];
    } else {
        [self completedTransitionFromViewController:nil toViewController:toViewController];
    }
}

- (void)beginTransitionFromViewController:(ISHPermissionRequestViewController *)fromViewController toViewController:(ISHPermissionRequestViewController *)toViewController {
    [self addChildViewController:toViewController];
    [[self view] addSubview:toViewController.view];
    [fromViewController willMoveToParentViewController:nil];
}

- (void)completedTransitionFromViewController:(ISHPermissionRequestViewController *)fromViewController toViewController:(ISHPermissionRequestViewController *)toViewController {
    [toViewController didMoveToParentViewController:self];
    [fromViewController.view removeFromSuperview];
    [fromViewController removeFromParentViewController];
    [self setCurrentViewController:toViewController];
}

@end
