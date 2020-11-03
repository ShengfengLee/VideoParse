# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'


def rx_swift()
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxWebKit'
  pod 'RxSwiftExt'
  pod 'NSObject+Rx'
end

target 'VideoParse' do
  use_frameworks!

  # Pods for VideoParse
  rx_swift()
  pod 'Alamofire'
  pod 'SnapKit'
 pod 'SwiftSoup'


  
  target 'VideoParseTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'VideoParseUITests' do
    # Pods for testing
  end

end
