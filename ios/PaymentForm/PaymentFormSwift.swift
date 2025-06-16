import Foundation
import React
import Cloudpayments

@objc(PaymentFormSwift)
public class PaymentFormSwift: NSObject {
  private var payer: PaymentDataPayer?
  private var recurrent: Recurrent?
  private var receipt: Receipt?
  private var paymentData: PaymentData?
  
  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;
  
  @objc
  public static let shared = PaymentFormSwift()
  
  @objc
  public func createPayer(_ payer: Dictionary<String, String>) {
    let payerConverted = Payer(methodData: payer)
    
    self.payer = PaymentDataPayer(
      firstName: payerConverted.firstName,
      lastName: payerConverted.lastName,
      middleName: payerConverted.middleName,
      birth: payerConverted.birthDay,
      address: payerConverted.address,
      street: payerConverted.street,
      city: payerConverted.city,
      country: payerConverted.country,
      phone: payerConverted.phone,
      postcode: payerConverted.postcode
    )
  }
  
  @objc
  public func createDataRecurrent(_ dataRecurrent: Dictionary<String, Any>) {
    let dataRecurrentConverted = DataRecurrent(data: dataRecurrent)
    
    self.recurrent = Recurrent(
      interval: dataRecurrentConverted.interval,
      period: dataRecurrentConverted.period,
      customerReceipt: receipt,
      amount: dataRecurrentConverted.amount,
      maxPeriods: dataRecurrentConverted.maxPeriods
    )
  }
  
  @objc
  public func createReceipt(_ receiptItems: Array<Dictionary<String, Any>>, receiptAmounts: Dictionary<String, Any>, dataPaymentReceipt: Dictionary<String, Any>) {
    let dataPaymentReceiptConverted = DataPaymentReceipt(data: dataPaymentReceipt)
    let receiptAmountsConverted = ReceiptAmounts(data: receiptAmounts)
    
    let amounts = Receipt.Amounts(
      electronic: receiptAmountsConverted.electronic,
      advancePayment: receiptAmountsConverted.advancePayment,
      credit: receiptAmountsConverted.credit,
      provision: receiptAmountsConverted.provision
    )
    
    var items: [Receipt.Item] = [];
    
    receiptItems.forEach { item in
      let currentItemConverted = ReceiptItem(data: item)
      
      items.append(Receipt.Item(
        label: currentItemConverted.label,
        price: currentItemConverted.price,
        quantity: currentItemConverted.quantity,
        amount: currentItemConverted.amount,
        method: currentItemConverted.method,
        object: currentItemConverted.objectt
      ))
    }
    
    receipt = Receipt(
      items: items,
      taxationSystem: dataPaymentReceiptConverted.taxationSystem,
      email: dataPaymentReceiptConverted.email,
      phone: dataPaymentReceiptConverted.phone,
      isBso: dataPaymentReceiptConverted.isBso,
      amounts: amounts
    )
  }
  
  @objc
  public func createPaymentData(_ dataOfPayment: Dictionary<String, Any>) {
    let paymentDataConverted = DageOfPayment(data: dataOfPayment)
    
    paymentData = PaymentData()
      .setAmount(paymentDataConverted.amount)
      .setCurrency(paymentDataConverted.currency)
      .setApplePayMerchantId(paymentDataConverted.applePayMerchantId ?? "")
      .setDescription(paymentDataConverted.description)
      .setAccountId(paymentDataConverted.accountId)
      .setInvoiceId(paymentDataConverted.invoiceId)
      .setEmail(paymentDataConverted.email)
      .setPayer(payer)
      .setReceipt(receipt)
      .setRecurrent(recurrent)
  }
  
  @objc
  public func open(_ configuration: Dictionary<String, Any> , resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    PaymentFormSwift.resolve = resolve;
    PaymentFormSwift.reject = reject;
    
    guard let paymentData = self.paymentData else {
      return
    }
    
    let paymentFormcontroller = PaymentFormController(
      paymentData: paymentData,
      configurationData: configuration
    );

    paymentFormcontroller.onOpen();
  }
  
  @objc
  private override init() {
    super.init()
  }
}
