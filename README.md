# <img src="AppIcon40x40_2x.png" align="center" width="40" height="40"> ISHPermissionKit

[![Travis Build Status](https://travis-ci.org/iosphere/ISHPermissionKit.svg?branch=master)](http://travis-ci.org/iosphere/ISHPermissionKit)&nbsp;
[![Version](http://cocoapod-badges.herokuapp.com/v/ISHPermissionKit/badge.png)](http://cocoadocs.org/docsets/ISHPermissionKit)

This framework provides a unified way of asking for user permissions on iOS. It
also provides UI to explain the permission requirements before presenting the
the system permission dialogue to the user. This allows the developer to postpone
the system dialogue. The framework provides no actual chrome, leaving the
developer and designer in charge of creating the views.

While you can use this framework to ask for a user's permission for multiple
data sources at the same time and out of context, you should continue to ask for
permission only when the app needs it. However, there might be occassions when
multiple permissions are required at the same time, e.g., when starting to record
location and motion data.

This framework also provides explicit ways to ask for the user's permission
where the system APIs only provide implicit methods of doing so.

**Supported permission categories:**

* AddressBook
* Calendar: Events and Reminders
* CoreLocation: Always and WhenInUse
* CoreMotion: Activity data (step counting, etc.)
* HealthKit *(use `+HealthKit` variants of the static library or framework)*
* Microphone
* Notifications: Local
* Photos: Camera Roll and Camera
* Social: Facebook, Twitter, SinaWeibo, TencentWeibo

The static library and sample app compile and run under iOS8 and iOS7. 
If compiled against iOS8 they make use of the latest available APIs 
(e.g., microphone, location, and local notification permissions) 
and fall back gracefully when running under iOS7.

<img src="demo.gif" align="center" width="320" height="568" alt="Sample App Demo"> 

In contrast to other libraries (such as
[JLPermissions](https://github.com/jlaws/JLPermissions) and
[ClusterPrePermissions](https://github.com/clusterinc/ClusterPrePermissions)) 
it allows you to present custom view controllers, ask for several
permissions in a sequence, and provides a unified API through subclasses.

Recommended reading: [The Right Way To Ask Users For iOS
Permissions](https://medium.com/@mulligan/the-right-way-to-ask-users-for-ios-permissions-96fa4eb54f2c "by Brenden Mulligan (@mulligan)")

# Roadmap

Missing features:

1. Resetting state correctly when device is reset
2. Permission monitoring and NSNotifications upon changes

Missing support for permissions for:

1. Remote notifications
2. Please file an issue for missing permissions

# How to use

## Installation

### Static Library

Add this Xcode project as a sub project of your app. Then link your app target 
against the static library (`ISHPermissionKitLib.a` or 
`ISHPermissionKitLib+HealthKit.a` if you require HealthKit support).
You will also need to add the static library as a target dependency. 
Both settings can be found in your app target's *Build Phases*.

Add `$(BUILT_PRODUCTS_DIR)/include/` (recursive) to your app 
target's *Framework Search Paths*.

Use `#import <ISHPermissionKit/ISHPermissionKit.h>` to import all public headers.

### Dynamically-Linked Framework

Add this Xcode project as a sub project of your app. Then add the framework
(`ISHPermissionKit.framework` or `ISHPermissionKit+HealthKit.framework` if you 
require HealthKit support) to the app's embedded binaries (on the *General*
tab of your app target's settings). On the *Build Phases* tab, verify that the
framework has also been added to the *Target Dependencies* and *Link Binary with
Libraries* phases, and that a new *Embed Frameworks* phase has been created.

The framework can be used as a module, so you can use `@import ISHPermissionKit;`
to import all public headers.
Further reading on Modules: [Clang Documentation](http://clang.llvm.org/docs/Modules.html)

**Note:** To link against dynamic frameworks on iOS, a deployment target of at
least iOS 8 is required.

### CocoaPods

You can use CocoaPods to install ISHPermissionKit as a static library. 
This is all you have to put in your Podfile:

```ruby
pod 'ISHPermissionKit'
```

The default installation does not include HealthKit support. To enable HealthKit 
permissions, the `ISHPermissionRequestHealthKitEnabled` preprocessor macro needs 
to be set. Use the following sample podfile to ensure the flag is still set 
after pod updates:

```ruby
pod 'ISHPermissionKit'

post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    target.build_configurations.each do |config|
      preprocessor_defs = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
      permission_kit_defs = ['$(inherited)', 'ISHPermissionRequestHealthKitEnabled=1']
      if preprocessor_defs
      	preprocessor_defs += permission_kit_defs
        preprocessor_defs.uniq!
      else
        preprocessor_defs = permission_kit_defs
      end
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = preprocessor_defs
    end
  end
end
```

See the [official guides](http://guides.cocoapods.org) to get started with CocoaPods.


## ISHPermissionsViewController

You can request permission for a single category or a sequence of categories.
The following example presents a `ISHPermissionsViewController` for `Activity`
and `LocationWhenInUse` permissions if needed.

```objective-c
NSArray *permissions = @[ 
    @(ISHPermissionCategoryLocationWhenInUse), 
    @(ISHPermissionCategoryActivity) 
    ];
ISHPermissionsViewController *vc = [ISHPermissionsViewController permissionsViewControllerWithCategories:permissions dataSource:self];

if (vc) {
    UIViewController *presentingVC = [self.window rootViewController];
    [presentingVC presentViewController:vc
                               animated:YES
                             completion:nil];
} 
```
The designated constructor returns nil if non of the categories allow a user
prompt (either because the user already granted or denied the permission, does
not want to be asked again, or the feature is simply not supported on the
device).

You can set a `completionBlock` or `delegate` (both optional) that will be
notified once the `ISHPermissionsViewController` has iterated through all
categories. If you do not set a delegate the view controller will simply be
dismissed once finished, and if set, the completion block will be called. If you
do set a delegate, the delegate is responsible for dismissing the view
controller.

The `dataSource` is required and must provide one instance of a
`ISHPermissionRequestViewController` for each requested 
`ISHPermissionCategory`.

The `ISHPermissionRequestViewController` provides `IBAction`s to _prompt for the
user's permission_, _ask later_, and _don't ask_. It does not however provide
any buttons or UI. Your subclass can create a view with text, images, and buttons
etc. explaining in greater detail why your app needs a certain permission. The
subclass should contain buttons that trigger at least one of the actions
mentioned above (see the header for their signatures). A _cancel button_ should
call `changePermissionStateToAskAgainFromSender:`. If your subclass overwrites 
any of these three actions, you must call super.

## ISHPermissionRequest

The `ISHPermissionRequest` can be used to determine the current state of a
permission category. It can also be used to trigger the user prompt asking for
permissions outside of the `ISHPermissionsViewController`.

You must use the additional (`...+All.h`) method `+requestForCategory:` to create the
appropriate request for the given permission category.

Here is how you check the permissions to access the microphone:

```objective-c
ISHPermissionRequest *r = [ISHPermissionRequest requestForCategory:ISHPermissionCategoryMicrophone];
BOOL granted = ([r permissionState] == ISHPermissionStateAuthorized);
```

The same example for local notifications (`granted` will always be true on iOS7): 

```objective-c
ISHPermissionRequest *r = [ISHPermissionRequest requestForCategory:ISHPermissionCategoryNotificationLocal];
BOOL granted = ([r permissionState] == ISHPermissionStateAuthorized);
```

# How to contribute

Contributions are welcome. Check out the roadmap and open issues. 
Adding support for more permission types is probably 
most "rewarding", you can find a few hints on how to get started below.

## Adding support for new permissions

You will need to create a new subclass of `ISHPermissionRequest` and add a
`ISHPermissionCategory` (make sure to use explicit values as these may be
persisted). Don't change existing values. Finally, wire it up in
`ISHPermissionRequest+All` by returning your new subclass in
`+requestForCategory:`.

Subclasses must implement at least two methods:

1. `- (ISHPermissionState)permissionState`
2. `- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion`

What these methods do depends on the mechanisms that the system APIs
provide. Ideally, `permissionState` should check the system authorization state
first and return appropriate internal enum values from
`ISHPermissionState`. If the system state is unavailable or is similar to
`kCLAuthorizationStatusNotDetermined` then this method should return
`internalPermissionState`. You should try to map system provided states to
`ISHPermissionState` without resorting to the `internalPermissionState` as much as
possible.


When requesting the permission state you should only store the result in
internalPermissionState if the state cannot easily be retrieved from the
system (as is the case, e.g., with M7-ActivityMonitoring).



App Icon designed by 
[Jason Grube (CC BY 3.0)](http://thenounproject.com/term/fingerprint/23303/) from the 
[Noun Project](http://thenounproject.com)

