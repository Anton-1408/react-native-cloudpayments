import Foundation
import React
import Cloudpayments;

@objc(CloudPaymentsAPISwift)
public class CloudPaymentsAPISwift: NSObject {
  private var api: CloudpaymentsApi?;
  
  @objc
  public static let shared = CloudPaymentsAPISwift()
  
  @objc
  private override init() {
    super.init()
  }
  
  @objc
  public func initialization(_ publicId: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    self.api = CloudpaymentsApi.init(publicId: publicId)
  }
  
  
  @objc
  public func getPublicKey(_ resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    CloudpaymentsApi.getPublicKey() {(info, error) in
      if let error = error {
        reject?("error", error.localizedDescription, nil);
      } else {
        var keyInfo: Dictionary<String, Any?> = [:];
        
        let infoConverted = info as! PublicKeyResponse?
        
        
        keyInfo["pem"] = infoConverted?.Pem
        keyInfo["version"] = infoConverted?.Version

        resolve?(keyInfo);
      }
    }
  }
  
  @objc
  public func getBinInfo(_ cardNumber: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    CloudpaymentsApi.getBankInfo(cardNumber: cardNumber) { (info, error) in
        if let error = error {
          reject?("error", error.message, nil);
        } else {
          var bankInfo: Dictionary<String, Any?> = [:];
          
          let infoConverted = info as! BankInfo?
          
          bankInfo["cardType"] = infoConverted?.cardType
          bankInfo["bankName"] = infoConverted?.bankName
          bankInfo["logoUrl"] = infoConverted?.logoURL
          bankInfo["currency"] = infoConverted?.currency
          bankInfo["convertedAmount"] = infoConverted?.convertedAmount
          bankInfo["hideCvv"] = infoConverted?.hideCvvInput
          
          resolve?(bankInfo);
        }
    }
  }
}
