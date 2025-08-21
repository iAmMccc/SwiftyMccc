#
# Be sure to run `pod lib lint McccSymbols.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'McccSymbols'
  s.version          = '0.1.0'
  s.summary          = 'SF Symbols 封装'

  s.homepage         = 'https://github.com/iAmMccc/McccSymbols'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iAmMccc' => 'https://github.com/iAmMccc' }
  s.source           = { :git => 'https://github.com/iAmMccc/McccSymbols.git', :tag => s.version.to_s }

  s.ios.deployment_target = '18.0'

  s.source_files = 'McccSymbols/Classes/**/*'

end
