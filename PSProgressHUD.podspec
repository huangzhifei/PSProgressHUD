#
#  Be sure to run `pod spec lint PSProgressHUD.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "PSProgressHUD"
  s.version      = "0.0.5"
  s.summary      = "使用链式的方式来封装MBProgressHUD，方便书写"

  s.description  = <<-DESC 
  使用链式的方式来封装MBProgressHUD,方便书写,基于MBProgressHUD的1.1.0版本，适配成0.9.x的样式
                   DESC

  s.homepage     = "https://github.com/huangzhifei/PSProgressHUD.git"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "eric" => "huangzhifei2009@126.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/huangzhifei/PSProgressHUD.git", :tag => s.version }

  s.source_files  = "PSProgressHUD/PSProgressHUD/*.{h,m}"

  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'

  s.requires_arc = true

  s.dependency 'MBProgressHUD', '~> 1.1.0'
  
end