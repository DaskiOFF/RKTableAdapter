#
# Be sure to run `pod lib lint RKTableAdapter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RKTableAdapter'
  s.version          = '0.1.13'
  s.summary          = 'Table Adapter'

  s.homepage         = 'https://github.com/DaskiOFF/RKTableAdapter'
  s.documentation_url = 'https://daskioff.github.io/RKTableAdapter/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DaskiOFF' => 'waydeveloper@gmail.com' }
  s.source           = { :git => 'https://github.com/DaskiOFF/RKTableAdapter.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/**/*'
  s.frameworks = 'UIKit'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Table and Collection Adapters

  0.1.13
    Add callback TrailingSwipeActionsConfigurationForRow (iOS 11+); 
    Add callback WillDisplayCell
    Add callback DidEndDisplayingCell

  0.1.12
    Update estimated height for row and height for row
    Fix batch updater
  
  0.1.11
    Replace semaphore to NSLock (fix random deinit crash)

  0.1.10
    Refactoring
    Update table cell without reloadRow if possible
    Delete + Insert to the same indexPath is no longer converted to an update (https://github.com/Instagram/IGListKit/issues/297)

  0.1.9
    Refactoring
    Fix batch update

  0.1.8
    Add Collection Adapter
    Update Example

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
end
