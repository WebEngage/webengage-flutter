#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint we_location_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'webengage_flutter_location'
  s.version          = '1.0.0'
  s.summary          = 'The plugin to add WebEngagae Location module in project.'
  s.description      = <<-DESC
The plugin to add WebEngagae Location module in project.
                       DESC
  s.homepage         = 'https://webengage.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'WebEngage' => 'mobile@webengage.com' }
  s.source           = { :path => '.' }
  s.source_files = 'webengage_flutter_location/Sources/webengage_flutter_location/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.swift_version = '5.0'
  s.dependency 'WebEngage','>= 6.10.0'
end
