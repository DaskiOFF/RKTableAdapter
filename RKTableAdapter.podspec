#
# Be sure to run `pod lib lint RKTableAdapter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RKTableAdapter'
  s.version          = '0.1.7'
  s.summary          = 'Table Adapter'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Table Adapter
  0.1.7
    Fix switch cell animation

  0.1.6
    Small fixes

  0.1.5
    Small fixes

  0.1.4
    Small fixes

  0.1.3
    fix CellCalculator and CellLayout (add open and public)

  0.1.2
    Add CellCalculator and CellLayout

  0.1.1
    Add support DeepDiff and batch update

  0.1.0
    Init
                       DESC

  s.homepage         = 'https://github.com/DaskiOFF/RKTableAdapter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DaskiOFF' => 'waydeveloper@gmail.com' }
  s.source           = { :git => 'https://github.com/DaskiOFF/RKTableAdapter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/**/*'
  
  # s.resource_bundles = {
  #   'RKTableAdapter' => ['RKTableAdapter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'DeepDiff'
end
