# Podspec for HKUIKeyboardManager
#   Created by Harrison Kong on 2020/01/19

Pod::Spec.new do |s|

  platform                = :ios
  s.ios.deployment_target = '13.0'

  s.name          = 'HKUIKeyboardManager'
  s.summary       = 'HK Keyboard Manager'
  s.requires_arc  = true
  s.version       = '1.1.0'
  s.license       = { :type => 'MIT' }
  s.author        = { 'Harrison Kong' => 'harrisonkong@skyroute66.com' }
  s.homepage      = 'https://github.com/harrisonkong/HKUIKeyboardManager'
  s.source        = { :git => 'https://github.com/harrisonkong/HKUIKeyboardManager.git',
                      :tag => '1.1.0' }
  s.dependency      'HKUIViewUtilities', '~> 1.0.0'
  s.framework     = 'UIKit'
  s.source_files  = 'HKUIKeyboardManager/**/*.swift'
  s.swift_version = '5.0'

end
