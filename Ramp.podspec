Pod::Spec.new do |spec|
    spec.name = 'Ramp'
    spec.version = '4.0.2'
    spec.license = 'proprietary'
    spec.summary = 'Ramp SDK for iOS'
    spec.homepage = 'https://ramp.network/'
    spec.authors = { 'Ramp Network' => 'dev@ramp.network' }
    spec.source = { :git => 'https://github.com/RampNetwork/ramp-sdk-ios.git', :tag => spec.version }
    spec.ios.deployment_target  = '11.0'
    spec.source_files = 'Sources/Ramp/*.swift'
    spec.resource_bundles = { 'Ramp' => 'Sources/Ramp/Resources/*' }
end
