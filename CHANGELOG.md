# <img src="icon.png" align="center" width="40" height="40"> Changelog

## 2.1.2

* Ensure compatibility with Xcode 10.2

## 2.1.1

* Deprecate social permissions
* Add debug hint when missing 'NSLocationAlwaysAndWhenInUseUsageDescription'

## 2.1.0

* Ready for Xcode 10 and iOS 12
* Bump deployment target to iOS 9
* Remove deprecated permission categories (AssetsLibrary and AddressBook-based APIs)
* Allow determination of possible requests without displaying any UI

## 2.0

This release requires additional setup to ensure your apps pass binary validation in iTunes Connect. Please study the [README](/README.md) file carefully.

* Ready for iOS 10
* New permission types: Siri, photo library, speech recognition,
  user notifications, music library
* All required usage descriptions will be asserted in `DEBUG` at the time of requesting a permission
* Carthage compatibility

## 1.2.0

* Provide callback to handle true errors
* Fix issues for social media account permissions if user had no user account:
  **this may require your implementations to handle the error to avoid asking the user
  again for permission**
* Add methods to query request-able and granted permissions given a set of categories
* Add some rudimentary unit tests

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
