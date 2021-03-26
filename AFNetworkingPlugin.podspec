#
# Be sure to run `pod lib lint AFNetworkingPlugin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AFNetworkingPlugin'
  s.version          = '0.0.1'
  s.summary          = '打印AFNetworking请求日志'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "用于Debug模式下打印AFNetworking请求日志"

  s.homepage         = 'https://github.com/zlfyuan'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zf' => 'zlfyuan1996@gmail.com' }
  s.source           = { :git => 'https://github.com/zlfyuan/AFNetworkingPlugin.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'AFNetworkingPlugin/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AFNetworkingPlugin' => ['AFNetworkingPlugin/Assets/*.png']
  # }

#   s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'AFNetworking'
end
