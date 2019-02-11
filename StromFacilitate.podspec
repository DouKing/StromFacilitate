Pod::Spec.new do |s|

  s.name         = "StromFacilitate"
  s.version      = "1.2.0"
  s.summary      = "iOS底层常用功能封装"
  s.homepage     = "https://github.com/DouKing/StromFacilitate"
  s.license      = "MIT"
  s.author       = { "wuyikai" => "wyk8916@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DouKing/StromFacilitate.git", :tag => "#{s.version}", :submodules => true }
  s.source_files = "Strom/Strom-header.h"
  s.requires_arc = true

  s.public_header_files = "Strom/Strom-header.h"


  s.subspec 'Core' do |ss|
    ss.source_files = 'Strom/Core/StromCore.h', 'Strom/Core/**/*.{h,m}', 'Strom/Resource/*.bundle'
    ss.public_header_files = 'Strom/Core/StromCore.h'
  end

  s.subspec 'Safe' do |ss|
    ss.source_files = 'Strom/Swizz/**/*.{h,m}', 'Strom/**/STMObjectRuntime.{h,m}'
  end

  s.subspec 'Network' do |ss|
    ss.source_files = 'Strom/Network/*.{h,m}', 'Strom/**/STMProxy.{h,m}'
    ss.public_header_files = 'Strom/Network/StromNetwork.h'
    ss.dependency 'AFNetworking', '~> 3.2.1'
  end

  s.subspec 'UI' do |ss|
    ss.source_files = 'Strom/UI/*.{h,m}'
    ss.public_header_files = 'Strom/UI/StromUI.h'
    ss.dependency 'StromFacilitate/Core'
  end

end
