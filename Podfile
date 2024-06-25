# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'Loochok' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Loochok
  
  # Network
  pod 'Alamofire'
  pod 'Kingfisher', '~> 7.0'
  
  # UI
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'IQKeyboardManagerSwift'
  
  # pod install
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
        #end
      end
    end
  end

end
