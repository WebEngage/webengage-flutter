Pod::Spec.new do |s|
  s.name             = 'webengage_flutter_ios'
  s.version          = '2.0.0-beta.1'
  s.summary          = 'WebEngage Flutter iOS SDK.'
  s.description      = <<-DESC
  WebEngage Flutter iOS SDK.
                       DESC
  s.homepage         = 'https://webengage.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'WebEngage' => 'mobile@webengage.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  if ENV['WEBENGAGE_USE_CORE'] == 'true'
       s.dependency 'WebEngage/Core','>= 6.10.0'
  else
       s.dependency 'WebEngage','>= 6.10.0'
  end
  s.platform = :ios, '10.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
