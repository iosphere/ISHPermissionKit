Pod::Spec.new do |s|

  s.name         = 'ISHPermissionKit'
  s.version      = '1.0.0'
  s.summary      = 'A polite and unified way of asking for permission on iOS.'
  s.description  = 'This framework provides a unified way of asking for user permissions on iOS. It also 
                    provides UI to explain the permission requirements before presenting the system
                    permission dialog to the user. This allows the developer to postpone the system dialog. The framework 
                    provides no actual chrome, leaving the developer and designer in charge of creating the views.'

  s.homepage     = 'https://github.com/iosphere/ISHPermissionKit.git'
  s.screenshots  = 'https://raw.githubusercontent.com/iosphere/ISHPermissionKit/master/assets/demo.gif'

  s.license      = 'New BSD'   
  s.authors      = { 'Felix Lamouroux' => 'felix@iosphere.de' }

  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/iosphere/ISHPermissionKit.git', :tag => '1.0.0' }
  s.source_files = 'ISHPermissionKit', 'ISHPermissionKit/**/*.{h,m}'
  s.requires_arc = true
  s.xcconfig     = { 'OTHER_LDFLAGS' => '-ObjC' }

end
