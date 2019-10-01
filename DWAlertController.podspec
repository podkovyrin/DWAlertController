Pod::Spec.new do |s|
  s.name             = 'DWAlertController'
  s.version          = '0.2.0'
  s.summary          = 'A UIAlertController reimplementation with controller containment support.'

  s.description      = <<-DESC
  DWAlertController is an UIAlertController that supports displaying any view controller instead of title and message.
  DWAlertController fully copies the look and feel of UIAlertController and has the same API.
  Supported features: iPhone / iPad compatible, Dynamic Type, Accessibility, Dark Mode, rotation, tinting action buttons and many more.
                       DESC

  s.homepage         = 'https://github.com/podkovyrin/DWAlertController'
  s.screenshots     = 'https://github.com/podkovyrin/DWAlertController/raw/master/assets/DWAlertController_Screens.png?raw=true'
  s.license          = 'MIT'
  s.author           = { 'Andrew Podkovyrin' => 'podkovyrin@gmail.com' }
  s.source           = { :git => 'https://github.com/podkovyrin/DWAlertController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/podkovyr'

  s.ios.deployment_target = '9.0'
  s.source_files = 'DWAlertController/**/*'
  s.public_header_files = 'DWAlertController/*.h'
  s.frameworks = 'UIKit'
end
