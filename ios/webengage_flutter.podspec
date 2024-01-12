Pod::Spec.new do |s|
  s.name             = 'webengage_flutter'
  s.version          = '1.3.1'
  s.summary          = 'WebEngage Flutter iOS SDK.'
  s.description      = <<-DESC
  WebEngage Flutter iOS SDK.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'WebEngage' => 'mobile@webengage.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'WebEngage','> 6.4.0'
  s.platform = :ios, '10.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
