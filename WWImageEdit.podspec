

Pod::Spec.new do |s|

s.name         = "WWImageEdit"
s.version      = "0.1.1"
s.summary      = "A short description of WWImageEdit."
s.description  = <<-DESC
this project provide WWImageEdit for iOS developer
DESC
s.homepage     = "https://github.com/a130785/WWImageEdit"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "wuwei" => "401260566@qq.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/a130785/WWImageEdit.git", :tag => "#{s.version}" }

s.source_files  = 'WWImageEdit/ImageBase/*.{h,m}','WWImageEdit/ImageEdit/*.{h,m}','WWImageEdit/ImageTools/*.{h,m}','WWImageEdit/ImageUtils/*.{h,m}'
s.requires_arc = true


end
