Pod::Spec.new do |s|

  s.name         = "StromFacilitate"
  s.version      = "1.1.4"
  s.summary      = "iOS底层常用功能封装"
  s.homepage     = "https://github.com/DouKing/StromFacilitate"
  s.license      = "MIT"
  s.author       = { "wuyikai" => "wyk8916@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/DouKing/StromFacilitate.git", :tag => "#{s.version}" }
  s.source_files = "Strom/Strom-header.h"
  s.requires_arc = true

  s.public_header_files = "Strom/Strom-header.h"


  s.subspec 'Foundation' do |ss|
    ss.source_files = 'Strom/Foundation/**/*.{h,m}'
  end

  s.subspec 'App' do |ss|
    ss.source_files = 'Strom/App/**/*.{h,m}', 'Strom/Resource/*.bundle', 'Strom/Foundation/**/NSBundle+STM.{h,m}'
  end

  s.subspec 'Swizz' do |ss|
    ss.source_files = 'Strom/Swizz/**/*.{h,m}', 'Strom/**/STMObjectRuntime.{h,m}'
  end

  s.subspec 'Utilities' do |ss|
    ss.source_files = 'Strom/Utilities/*.{h,m}'
  end

  s.subspec 'Config' do |ss|
    ss.source_files = 'Strom/Config/*.{h,m}'
  end

  s.subspec 'Security' do |ss|
    ss.source_files = 'Strom/Security/*.{h,m}', 'Strom/**/NSString+STM.{h,m}', 'Strom/**/NSString+Hash.{h,m}'
  end

  s.subspec 'UI' do |ss|
    ss.source_files = 'Strom/UI/*.{h,m}', 'Strom/Style/*.{h,m}', 'Strom/**/STMObjectRuntime.{h,m}'
  end

end
