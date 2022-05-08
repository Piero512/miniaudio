#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint miniaudio.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'miniaudio'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.frameworks = 'AudioUnit','CoreAudio','CoreFoundation'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' ,}
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', 'OTHER_CFLAGS' => "$(inherited) -DMA_NO_EXTERNAL_LINKING -DMA_API='extern __attribute__((visibility(\"default\"))) __attribute__((used))'"}
  s.swift_version = '5.0'
end
