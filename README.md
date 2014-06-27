# <img src="AppIcon40x40@2x.png" align="center" width="40" height="40" style="margin: 25px 25px;"> ISHPermissionKit

This framework provides a unified way of asking for user permissions on iOS. It also provides UI to explain the permission requirements before presenting the user with the system permission dialog. This allows the developer to postpone the system dialog. The framework provides no actual chrome, leaving the developer and designer in charge of creating the views. 

While you can use this framework to ask for a user's permission to multiple things at the same time and out of context, you should continue to ask for permission only when the app needs it. However there might be occassions, where multiple permissions are required at the same time: e.g. when starting to record location and motion data.

Recommended reading: [The Right Way To Ask Users For iOS Permissions](http://techcrunch.com/2014/04/04/the-right-way-to-ask-users-for-ios-permissions/ "by Brenden Mulligan (@mulligan)") 


# Roadmap

Missing features:

1. Add Support for iOS7 
2. Documentation
3. Resetting state correctly when device is reset
4. CocoaPod
5. Improve transitions between sub view controllers


Missing support for permissions to:

1. Health-App
2. AdressBook
3. Calender
4. Social-Services
5. Reminders
6. ...

Missing Support iOS7:
1. Activity permission only works on iOS8
2. CoreLocation permission only works on iOS8

# How to contribute

## Adding support for new permissions

You will need to create a new subclass of `ISHPermissionRequest` and add a `ISHPermissionCategory` (make sure to use explicit values as these may be persisted). Don't change existing values. Finally wire it up in `ISHPermissionRequest+All` by returning your new subclass in `+requestForCategory:`.

Subclasses must implement at least two methods:

1. `- (ISHPermissionState)permissionState` 
2. `- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion`

What these methods will do depends on the mechanism that the system APIs provide. Ideally `permissionState` should check the system authorization state first and should return appropriate internal enum values from `ISHPermissionState`. If the system state is unavailable or is similar to `kCLAuthorizationStatusNotDetermined` then this method should return `internalPermissionState`. You should try to map system provided states to ISHPermissionState without resorting the internalPermissionState as much as possible.

When requesting the permission state you should only store the result in internalPermissionState if the state cannot easily be retrieved from the the system (as is the case e.g. with M7-ActivityMonitoring).


App Icon designed by [Jason Grube (CC BY 3.0)](http://thenounproject.com/term/fingerprint/23303/) from the [Noun Project](http://thenounproject.com)

 