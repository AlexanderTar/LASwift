#
# Be sure to run `pod lib lint LASwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LASwift'
  s.version          = '0.2.5'
  s.summary          = 'Linear algebra library for Swift language'

  s.description      = <<-DESC
This library provides most of linear algebra operations on vectors and matrices
required to implement machine learning algorithms. Library syntax is inspired by
Matlab matrix manipulation and Haskell linear algebra library 'hmatrix'
                       DESC

  s.homepage         = 'https://github.com/alexandertar/LASwift'
  s.license          = { :type => 'BSD-3-Clause', :file => 'LICENSE' }
  s.author           = { 'Alexander Taraymovich' => 'taraymovich@me.com' }
  s.source           = { :git => 'https://github.com/alexandertar/LASwift.git', :tag => s.version.to_s }

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'

  s.swift_version = '5.0'

  s.frameworks = 'Accelerate'

  s.source_files = 'Sources/**/*'
end
