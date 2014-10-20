Pod::Spec.new do |s|

  s.name         = 'ISHPermissionKit'
  s.version      = '0.6.0'
  s.summary      = 'A unified way for iOS apps to request user permissions.'
  s.description  = 'This framework provides a unified way of asking for user permissions on iOS. It also 
                    provides UI to explain the permission requirements before presenting the user with the 
                    system permission dialogue. This allows the developer to postpone the system dialogue. The framework 
                    provides no actual chrome, leaving the developer and designer in charge of creating the views.'

  s.homepage     = 'https://github.com/iosphere/ISHPermissionKit.git'
  s.screenshots  = 'https://raw.githubusercontent.com/iosphere/ISHPermissionKit/master/demo.gif'

  s.license      = 'New BSD'   
  s.authors      = { 'Felix Lamouroux' => 'felix@iosphere.de' }

  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/iosphere/ISHPermissionKit.git', :tag => '0.6.0' }
  s.source_files = 'ISHPermissionKit', 'ISHPermissionKit/**/*.{h,m}'
  s.requires_arc = true
  s.xcconfig     = { 'OTHER_LDFLAGS' => '-ObjC' }

end
