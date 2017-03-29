Pod::Spec.new do |s|

  s.name         = "StromFacilitate"
  s.version      = "1.0.0"
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
    ss.source_files = 'Strom/**/NS{String,Data,Dictionary}+STM.{h,m}'
  end

  s.subspec 'Swizz' do |ss|
    ss.source_files = 'Strom/**/NS{Array,MutableArray,Dictionary,MutableDictionary}+STM.{h,m}', 'Strom/**/STMObjectRuntime.{h,m}'
  end

  s.subspec 'Utilities' do |ss|
    ss.source_files = 'Strom/**/STMObjectRuntime.{h,m}'
  end

  s.subspec 'Config' do |ss|
    ss.source_files = 'Strom/**/STMConfiguration.{h,m}'
  end

  s.subspec 'Security' do |ss|
    ss.source_files = 'Strom/**/STMRSAEncryptor.{h,m}', 'Strom/**/NSString+STM.{h,m}'
  end

  s.subspec 'Style' do |ss|
    ss.source_files = 'Strom/**/UI{Color,Image}+STM.{h,m}'
  end

end
