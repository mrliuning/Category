#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#


Pod::Spec.new do |s|
  s.name             = 'Category'
  s.version          = '0.0.1'
  s.summary          = 'Category'
  s.description      = <<-DESC
Category
                       DESC
  s.license          = 'MIT' 
  s.homepage         = 'http://tjos.com/seeyon/main.do'
  s.author           = { 'tojoy' => 'hefeijiang@tojoy.com' }

  s.source       = { :svn => "", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = '*.{h,m}'

  s.dependency 'Aspects',  '~> 1.4.1'
  s.dependency 'Macro'
  s.dependency 'HUDManager'
  s.dependency 'YYText'

end
