Pod::Spec.new do |s|
  s.name             = 'webengage_flutter_ios'
  s.version          = '2.0.0-beta.2'
  s.summary          = 'WebEngage Flutter iOS SDK.'
  s.description      = <<-DESC
  WebEngage Flutter iOS SDK.
                       DESC
  s.homepage         = 'https://webengage.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'WebEngage' => 'mobile@webengage.com' }
  s.source           = { :path => '.' }
  s.source_files = 'webengage_flutter_ios/Sources/webengage_flutter_ios/**/*.{h,m}'
  s.public_header_files = 'webengage_flutter_ios/Sources/webengage_flutter_ios/include/**/*.h'
  s.dependency 'Flutter'
  if ENV['WEBENGAGE_USE_CORE'] == 'true'
       s.dependency 'WebEngage/Core','>= 6.10.0'
  else
       s.dependency 'WebEngage','>= 6.10.0'
  end
  s.platform = :ios, '13.0'

end
