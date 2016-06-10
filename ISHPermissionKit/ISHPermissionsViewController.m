//
//  ISHPermissionsViewController.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionsViewController.h"
#import "ISHPermissionRequestViewController.h"
#import "ISHPermissionRequest+All.h"
#import "ISHPermissionRequestViewController+Private.h"
#import "ISHPermissionRequestViewControllerDelegate.h"

@interface ISHPermissionsViewController () <ISHPermissionRequestViewControllerDelegate>
@property BOOL hasBeenInitialized;

@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSArray *permissionCategories;
@property (nonatomic) NSArray *permissionRequests;
@property (nonatomic) ISHPermissionRequestViewController *currentViewController;

@property (nonatomic, readwrite, weak) id <ISHPermissionsViewControllerDataSource> dataSource;
@end

@implementation ISHPermissionsViewController

#pragma mark - Init

+ (instancetype)permissionsViewControllerWithCategories:(NSArray *)categories dataSource:(id <ISHPermissionsViewControllerDataSource>)dataSource {
    if (!categories || !dataSource) {
        NSAssert(NO, @"Required parameters 'categories' (%@) or 'dataSource' (%@) are missing.", categories, dataSource);
        return nil;
    }

    ISHPermissionsViewController *vc = [ISHPermissionsViewController new];
    
    [vc setDataSource:dataSource];
    [vc setupRequestablePermissionsCategoriesFromArray:categories];
    
    if (!vc.permissionCategories.count) {
        return nil;
    }
    
    return vc;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self commonInitIfNeeded];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self commonInitIfNeeded];
    return self;
}

- (instancetype)init {
    self = [super init];
    [self commonInitIfNeeded];
    return self;
}

- (void)commonInitIfNeeded {
    if (self.hasBeenInitialized) {
        return;
    }
    self.hasBeenInitialized = YES;
    [self commonInit];
}

- (void)commonInit {
    [self setCurrentIndex:0];
    UIModalPresentationStyle phonePresentation = UIModalPresentationCurrentContext;
#ifdef __IPHONE_8_0
    if ([self respondsToSelector:@selector(presentationController)]) {
        // if built for and running on iOS8 use over presentation context to use blurred background
        phonePresentation = UIModalPresentationOverCurrentContext;
    }
#endif
    BOOL isIpad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    [self setModalPresentationStyle:isIpad ? UIModalPresentationFormSheet:phonePresentation];
}

#pragma mark -

- (void)loadView {
    UIView *view = nil;
    
#ifdef __IPHONE_8_0
    if (NSClassFromString(@"UIVisualEffectView") && (self.modalPresentationStyle != UIModalPresentationFormSheet)) {
        view = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [view setBounds:[[UIScreen mainScreen] bounds]];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        self.view = view;
    }
#endif
    
    if (!view) {
        [super loadView];
        [self.view setBackgroundColor:[UIColor blackColor]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert(self.dataSource, @"Datasource should not be nil");
    
    // setup UI for first permission category:
    [self transitionToPermissionCategoryAtIndex:self.currentIndex];
}

- (void)transitionToPermissionCategoryAtIndex:(NSUInteger)index {
    NSAssert(index < self.permissionCategories.count, @"Transition must lead to an index within bounds");
    
    ISHPermissionCategory category = [self categoryAtIndex:index];
    
    // retrieve view controller for permissions request from data source
    ISHPermissionRequestViewController *newVC = [self.dataSource permissionsViewController:self requestViewControllerForCategory:category];
    NSAssert(newVC, @"Datasource should return an instance of ISHPermissionRequestViewController in -permissionsViewController:requestViewControllerForCategory:");
    
    // configure request view controller
    [newVC setPermissionDelegate:self];
    [newVC setPermissionCategory:category];
    [newVC setPermissionRequest:[self requestAtIndex:index]];
    
    [self transitionFromViewController:self.currentViewController toViewController:newVC];
}

- (ISHPermissionCategory)categoryAtIndex:(NSUInteger)index {
    return [[self.permissionCategories objectAtIndex:index] integerValue];
}

- (ISHPermissionRequest *)requestAtIndex:(NSUInteger)index {
    if (index >= self.permissionRequests.count) {
        return nil;
    }
    
    return [self.permissionRequests objectAtIndex:index];
}

- (void)setupRequestablePermissionsCategoriesFromArray:(NSArray *)neededCategories {
    NSArray *requestableCategories = [ISHPermissionRequest requestablePermissionsForCategories:neededCategories];
    NSMutableArray *requests = [NSMutableArray arrayWithCapacity:requestableCategories.count];
    BOOL dataSourceConfiguresRequests = [self.dataSource respondsToSelector:@selector(permissionsViewController:didConfigureRequest:)];
    
    for (NSNumber *categoryObj in requestableCategories) {
        ISHPermissionCategory category = [categoryObj integerValue];
        ISHPermissionRequest *request = [ISHPermissionRequest requestForCategory:category];
        
        if (dataSourceConfiguresRequests && request.allowsConfiguration) {
            [self.dataSource permissionsViewController:self didConfigureRequest:request];
        }
        
        [requests addObject:request];
    }

    [self setPermissionRequests:[requests copy]];
    [self setPermissionCategories:requestableCategories];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutChildViewControllerView:self.currentViewController.view];
}

- (void)layoutChildViewControllerView:(UIView *)childView {
    UIView *containerView = self.view;
    
    [childView setBounds:containerView.bounds];
    [childView setCenter:CGPointMake(CGRectGetMidX(containerView.bounds), CGRectGetMidY(containerView.bounds))];
}

#pragma mark - ISHPermissionRequestViewControllerDelegate
- (void)permissionRequestViewController:(ISHPermissionRequestViewController *)vc didCompleteWithState:(ISHPermissionState)state {
    /* Determine the nextIndex that is requestable.
    
       There might be dependencies between the permission categories.
       Currently this is only the case when asking asking for 
       whenInUse and always location permissions in one set.
       E.g. the user might be asked for whenInUse and then always location 
       permissions. If whenInUse permissions are denied, always permissions 
       must be skipped.
    */
    ISHPermissionState nextState = ISHPermissionStateDenied;
    NSUInteger nextIndex = self.currentIndex;
    do {
        nextIndex++;
        ISHPermissionRequest *req = [self requestAtIndex:nextIndex];
        nextState = [req permissionState];
    } while (nextIndex < self.permissionCategories.count && !ISHPermissionStateAllowsUserPrompt(nextState));
    
    // dismiss if we reached the end, or transition to next permission category
    if (nextIndex == self.permissionCategories.count) {
        [self.delegate permissionsViewControllerDidComplete:self];
        
        if (!self.delegate) {
            [self dismissViewControllerAnimated:YES completion:self.completionBlock];
        } else if (self.completionBlock) {
            self.completionBlock();
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
        // prepare incoming view controller:
        [self layoutChildViewControllerView:toViewController.view];
        [toViewController.view setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
        
        [self transitionFromViewController:fromViewController
                          toViewController:toViewController
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionNone | UIViewAnimationOptionCurveEaseInOut
                                animations:^{
                                    [self.view bringSubviewToFront:fromViewController.view];
                                    [toViewController.view setTransform:CGAffineTransformIdentity];
                                    [fromViewController.view setTransform:CGAffineTransformMakeTranslation(0, fromViewController.view.bounds.size.height)];
                                }
         
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        [self completedTransitionFromViewController:fromViewController toViewController:toViewController];
                                    }
                                }];
    } else {
        [[self view] addSubview:toViewController.view];
        [toViewController.view setFrame:self.view.bounds];
        [self completedTransitionFromViewController:nil toViewController:toViewController];
    }
}

- (void)beginTransitionFromViewController:(ISHPermissionRequestViewController *)fromViewController toViewController:(ISHPermissionRequestViewController *)toViewController {
    [self addChildViewController:toViewController];
    [fromViewController willMoveToParentViewController:nil];
}

- (void)completedTransitionFromViewController:(ISHPermissionRequestViewController *)fromViewController toViewController:(ISHPermissionRequestViewController *)toViewController {
    [toViewController didMoveToParentViewController:self];
    [fromViewController.view removeFromSuperview];
    [fromViewController removeFromParentViewController];
    [self setCurrentViewController:toViewController];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.currentViewController.preferredStatusBarStyle;
}

@end
