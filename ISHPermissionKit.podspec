Pod::Spec.new do |s|

  s.name         = 'ISHPermissionKit'
  s.version      = '2.1.2'
  s.summary      = 'A polite and unified way of asking for permission on iOS.'
  s.description  = 'This framework provides a unified way of asking for user permissions on iOS. It also
                    provides UI to explain the permission requirements before presenting the system
                    permission dialog to the user. This allows the developer to postpone the system dialog. The framework
                    provides no actual chrome, leaving the developer and designer in charge of creating the views.'

  s.homepage     = 'https://github.com/iosphere/ISHPermissionKit'
  s.screenshots  = 'https://raw.githubusercontent.com/iosphere/ISHPermissionKit/master/assets/demo.gif'

  s.license      = 'New BSD'
  s.authors      = { 'Felix Lamouroux' => 'felix@iosphere.de' }

  s.platform     = :ios, '9.0'
  s.source       = { :git => 'https://github.com/iosphere/ISHPermissionKit.git', :tag => s.version.to_s }
  s.module_name = 'ISHPermissionKit'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files         = 'ISHPermissionKit/**/*.{h,m}'
    core.private_header_files = 'ISHPermissionKit/Private/**/*.h'
    core.pod_target_xcconfig  = { 'OTHER_LDFLAGS' => '-ObjC' }
    core.requires_arc         = true
  end

  s.subspec 'Motion' do |motion|
    motion.dependency 'ISHPermissionKit/Core'
    motion.weak_framework       = 'CoreMotion'
    feature_flags               = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestMotionEnabled' }
    motion.pod_target_xcconfig  = feature_flags
    motion.user_target_xcconfig = feature_flags
  end

  s.subspec 'Health' do |health|
   health.dependency 'ISHPermissionKit/Core'
   health.weak_framework       = 'HealthKit'
   feature_flags               = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestHealthKitEnabled' }
   health.pod_target_xcconfig  = feature_flags
   health.user_target_xcconfig = feature_flags
  end

  s.subspec 'Location' do |location|
    location.dependency 'ISHPermissionKit/Core'
    location.weak_framework       = 'CoreLocation'
    feature_flags                 = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestLocationEnabled' }
    location.pod_target_xcconfig  = feature_flags
    location.user_target_xcconfig = feature_flags
  end

  s.subspec 'Microphone' do |mic|
    mic.dependency 'ISHPermissionKit/Core'
    mic.weak_framework       = 'AVFoundation'
    feature_flags            = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestMicrophoneEnabled' }
    mic.pod_target_xcconfig  = feature_flags
    mic.user_target_xcconfig = feature_flags
  end

  s.subspec 'PhotoLibrary' do |photo|
    photo.dependency 'ISHPermissionKit/Core'
    photo.weak_framework       = 'Photos'
    feature_flags              = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestPhotoLibraryEnabled' }
    photo.pod_target_xcconfig  = feature_flags
    photo.user_target_xcconfig = feature_flags
  end

  s.subspec 'Camera' do |cam|
    cam.dependency 'ISHPermissionKit/Core'
    cam.weak_framework       = 'AVFoundation'
    feature_flags            = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestCameraEnabled' }
    cam.pod_target_xcconfig  = feature_flags
    cam.user_target_xcconfig = feature_flags
  end

  s.subspec 'Notifications' do |note|
    note.dependency 'ISHPermissionKit/Core'
    note.weak_framework       = 'UIKit', 'UserNotifications'
    feature_flags             = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestNotificationsEnabled' }
    note.pod_target_xcconfig  = feature_flags
    note.user_target_xcconfig = feature_flags
  end

  s.subspec 'SocialAccounts' do |social|
    social.dependency 'ISHPermissionKit/Core'
    social.weak_framework       = 'Accounts'
    feature_flags               = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestSocialAccountsEnabled' }
    social.pod_target_xcconfig  = feature_flags
    social.user_target_xcconfig = feature_flags
  end

  s.subspec 'Contacts' do |contacts|
    contacts.dependency 'ISHPermissionKit/Core'
    contacts.weak_framework       = 'Contacts'
    feature_flags                 = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestContactsEnabled' }
    contacts.pod_target_xcconfig  = feature_flags
    contacts.user_target_xcconfig = feature_flags
  end

  s.subspec 'Calendar' do |cal|
    cal.dependency 'ISHPermissionKit/Core'
    cal.weak_framework       = 'EventKit'
    feature_flags            = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestCalendarEnabled' }
    cal.pod_target_xcconfig  = feature_flags
    cal.user_target_xcconfig = feature_flags
  end

  s.subspec 'Reminders' do |rem|
    rem.dependency 'ISHPermissionKit/Core'
    rem.weak_framework       = 'EventKit'
    feature_flags            = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestRemindersEnabled' }
    rem.pod_target_xcconfig  = feature_flags
    rem.user_target_xcconfig = feature_flags
  end

  s.subspec 'Siri' do |siri|
    siri.dependency 'ISHPermissionKit/Core'
    siri.weak_framework       = 'Intents'
    feature_flags             = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestSiriEnabled' }
    siri.pod_target_xcconfig  = feature_flags
    siri.user_target_xcconfig = feature_flags
  end

  s.subspec 'Speech' do |speech|
    speech.dependency 'ISHPermissionKit/Core'
    speech.weak_framework       = 'Speech'
    feature_flags               = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestSpeechEnabled' }
    speech.pod_target_xcconfig  = feature_flags
    speech.user_target_xcconfig = feature_flags
  end

  s.subspec 'MusicLibrary' do |music|
    music.dependency 'ISHPermissionKit/Core'
    music.weak_framework       = 'MediaPlayer'
    feature_flags              = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ISHPermissionRequestMusicLibraryEnabled' }
    music.pod_target_xcconfig  = feature_flags
    music.user_target_xcconfig = feature_flags
  end

end
