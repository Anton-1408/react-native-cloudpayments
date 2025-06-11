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
  public func initialization(_ publicId: String) {
    self.api = CloudpaymentsApi.init(publicId: publicId)
  }
  
  @objc
  public func getPublicKey(_ resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    reject?("error", "method not yet available", nil);
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
          bankInfo["bankName"] = nil
          bankInfo["logoUrl"] = infoConverted?.logoURL
          bankInfo["currency"] = infoConverted?.currency
          bankInfo["convertedAmount"] = infoConverted?.convertedAmount
          bankInfo["hideCvv"] = infoConverted?.hideCvvInput
          
          resolve?(bankInfo);
        }
    }
  }
}
