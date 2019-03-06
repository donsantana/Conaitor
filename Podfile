
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!
target "Conaitor" do
    pod 'Socket.IO-Client-Swift'
    pod 'Canvas'
    pod 'AFNetworking'
    pod 'SwiftyJSON'
    pod 'MaterialComponents/TextFields'
    pod 'TextFieldEffects'

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
    end
    
end
