Pod::Spec.new do |s|
    s.name             = 'WolfSec'
    s.version          = '3.0.0'
    s.summary          = 'A library of conveniences for security-related functionality.'

    # s.description      = <<-DESC
    # TODO: Add long description of the pod here.
    # DESC

    s.homepage         = 'https://github.com/wolfmcnally/WolfSec'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfSec.git', :tag => s.version.to_s }

    s.swift_version = '5.0'

    s.source_files = 'WolfSec/Classes/**/*'

    s.ios.deployment_target = '9.3'
    s.macos.deployment_target = '10.13'
    s.tvos.deployment_target = '11.0'

    s.module_name = 'WolfSec'

    s.dependency 'WolfPipe'
    s.dependency 'WolfFoundation'
end
