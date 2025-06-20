require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "CloudpaymentsSdk"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/Anton-1408/react-native-cloudpayments.git", :tag => "#{s.version}" }
  s.author       = { "Anton Votinov" => "antonvotinov@gmail.com" }
  s.source_files = "ios/**/*.{h,m,mm,cpp,swift}"
  s.private_header_files = "ios/**/*.h"

  s.dependency "Cloudpayments"
  s.dependency "CloudpaymentsNetworking"

  install_modules_dependencies(s)
end