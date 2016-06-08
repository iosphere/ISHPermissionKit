# <img src="icon.png" align="center" width="40" height="40"> Changelog

## 1.1.0

* Improves CocoaPods integration
  * README examples updated to work with CocoaPods 1.0
  * Private headers are marked private in Podspec
  * Adds subspec for Health support
* Improves Swift support by adding nullability annotations
* Internal refactoring

## 1.0.0

* Improves documentation
  * Improves header documentation
  * Adds shared schemes to allow builds via `xcodebuild`
  * Adds changelog file (this one!)
  * Adds repo icon (shown, e.g., in SourceTree)
  * Adds appledoc config file (allows `appledoc .` within the root directory)

## 0.9.0

* Added support for remote notifications
* Added source annotations to work better with Swift
* Fixes project configuration warnings
* Removes Xcode 6/iOS 8 SDK build support (iOS 7 is still the deployment target)

## 0.8.0

* Allows upgrade from `WhenInUse` to `Always` location permission
* Adds support for dependencies between permissions
* Bugfixes: Camera, Microphone permissions

## 0.7.0

* HealthKit fixes

## 0.6.0

* HealthKit is not used in default setting. If you need to use HealthKit please consult the readme and use the ISHPermissionKitLib+HealthKit variant.
* This is an important update if you do not use HealthKit as you might otherwise get a rejection from Apple for not providing a privacy policy or have no reason to link to HealthKit. 

## 0.5.0

* Added additional permissions:
  * Health-App
  * AdressBook
  * Calendar
  * Social-Services
  * Reminders
* Changed designated constructor for `ISHPermissionsViewController`: `+permissionsViewControllerWithCategories:dataSource:`
* Improved UI layout on iPad

## 0.1.1

First version with support for permissions to:

* CoreLocation: Always and WhenInUse
* CoreMotion: Activity data (step counting, etc.)
* Microphone
* Photos: Camera Roll and Camera
* LocalNotifications
