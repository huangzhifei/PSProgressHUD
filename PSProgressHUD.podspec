Pod::Spec.new do |s|


  s.name         = "PSProgressHUD"
  s.version      = "0.0.1"
  s.summary      = "使用链式的方式来封装MBProgressHUD,方便书写"

  s.description  = <<-DESC
    使用链式的方式来封装MBProgressHUD,方便书写,是基于MBProgressHUD的0.9.2版本，会自动带上此版本
                   DESC

  s.homepage     = "https://github.com/huangzhifei/PSProgressHUD.git"
  s.license      = "MIT"
  s.author             = { "huangzhifei" => "huangzhifei2009@126.com" }
  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/huangzhifei/PSProgressHUD.git", :tag => s.version }
  s.source_files  = "PSProgressHUD/PSProgressHUD/*.{h,m}"
  s.frameworks = 'UIKit', 'Foundation'
  s.requires_arc = true
  s.dependency "MBProgressHUD", "0.9.2"

end