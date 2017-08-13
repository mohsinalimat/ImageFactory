Pod::Spec.new do |s|
  s.name             = "ImageFactory"
  s.version          = "1.1.0"
  s.summary          = "An easy way to make UIImage objects."
  s.description      = <<-DESC
                        EnumCollection is an easy way to make UIImage objects.
                        DESC

  s.homepage         = "https://github.com/Meniny/ImageFactory"
  s.license          = 'MIT'
  s.author           = { "Elias Abel" => "Meniny@qq.com" }
  s.source           = { :git => "https://github.com/Meniny/ImageFactory.git", :tag => s.version.to_s }
  s.social_media_url = 'https://meniny.cn/'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ImageFactory/**/*.{h,swift}'
  s.public_header_files = 'ImageFactory/**/*{.h}'
  s.frameworks = 'Foundation', 'UIKit'
#s.dependency ""
end
