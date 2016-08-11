Pod::Spec.new do |s|

  s.name         = "StromFacilitate"
  s.version      = "0.1.1"
  s.summary      = "iOS底层常用功能封装"
  s.homepage     = "https://github.com/DouKing/StromFacilitate"
  s.license      = "MIT"
  s.author       = { "wuyikai" => "wuyikai@secoo.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/DouKing/StromFacilitate.git", :tag => "0.1.1" }
  s.source_files = "Strom/**/*.{h,m}"
  s.requires_arc = true

end
