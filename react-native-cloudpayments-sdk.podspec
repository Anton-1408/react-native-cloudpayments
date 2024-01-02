require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-cloudpayments-sdk"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]

  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/Anton-1408/react-native-cloudpayments.git", :tag => "#{s.version}" }
  s.author       = { "Anton Votinov" => "antonvotinov@gmail.com" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"

  s.dependency "React-Core"
  s.dependency "Cloudpayments"
  s.dependency "CloudpaymentsNetworking"
  s.dependency "CardIO"
end