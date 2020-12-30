#
#  Be sure to run `pod spec lint YXCycleScrollView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|


  spec.name         = "YXCycleScrollView"
  spec.version      = "1.0.1"
  spec.summary      = "多样式轮播图"
  spec.description  = "一款简单实用多样式轮播图控件，可自定义样式；支持左右、上下滚动，支持XIB创建和设置属性"
  spec.homepage     = "https://github.com/gouzyi/YXCycleScrollView.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.requires_arc = true
  spec.platform     = :ios, "8.0"
  spec.author             = { "zainguo" => "572249347@qq.com" }
  spec.social_media_url   = "https://www.jianshu.com/u/b2d703ff4984"

  spec.source       = { :git => "https://github.com/gouzyi/YXCycleScrollView.git", :tag => spec.version }

  spec.source_files  = "YXCycleScrollView/**/*.{h,m}"

  spec.dependency 'SDWebImage'


end
