#
# Be sure to run `pod lib lint ATPermission.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                    = 'ATPermission'
  s.version                 = '0.1.8'
  s.summary                 = '系统权限请求'
  s.homepage                = 'https://github.com/ablettchen/ATPermission'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'ablett' => 'ablettchen@gmail.com' }
  s.source                  = { :git => 'https://github.com/ablettchen/ATPermission.git', :tag => s.version.to_s }
  s.social_media_url        = 'https://twitter.com/ablettchen'
  s.ios.deployment_target   = '9.0'
  s.source_files            = 'ATPermission/**/*.{h,m}'
  s.resource                = 'ATPermission/ATPermission.bundle'
  s.requires_arc            = true
  s.dependency 'ATAlert'
  s.dependency 'ATCategories'

end
