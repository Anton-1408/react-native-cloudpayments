public struct PublicKeyResponse: Codable {
    public let Pem: String?
    public let Version: Int?
}

public enum NameCardType: String, Codable {
    case unknown = "Unknown"
    case visa = "Visa"
    case masterCard = "MasterCard"
    case maestro = "Maestro"
    case mir = "MIR"
    case jcb = "Jcb"
    case jcb15 = "Jcb15"
    case americanExpress = "AmericanExpress"
    case troy = "Troy"
    case dankort = "Dankort"
    case discover = "Discover"
    case diners = "Diners"
    case instapayments = "Instapayments"
    case humo = "Humo"
    case uatp = "Uatp"
    case unionPay = "UnionPay"
    case uzcard = "Uzcard"
    
    var string: String {
        switch self {
        case .jcb, .jcb15: return NameCardType.jcb.rawValue
        default: return rawValue
        }
    }
}

public struct BankInfo: Codable {
    public let logoURL: String?
    public let convertedAmount: String?
    public let currency: String?
    public let hideCvvInput: Bool?
    public let isCardAllowed: Bool?
    public let cardType: NameCardType.RawValue?
    public let countryCode: Int?
}

public struct Parametres3DS {
  var transactionId: String
  var paReq: String
  var acsUrl: String
  
  init(parametres3DS: Dictionary<String, String>) {
    self.acsUrl = parametres3DS["acsUrl"] ?? "";
    self.paReq = parametres3DS["paReq"] ?? "";
    self.transactionId = parametres3DS["md"] ?? "";
  }
}

struct MethodData {
  var merchantId: String
  var supportedNetworks: Array<String>
  var countryCode: String
  var currencyCode: String

  init(methodData: Dictionary<String, Any>) {
    self.countryCode = methodData["countryCode"] as! String;
    self.currencyCode = methodData["currencyCode"] as! String;
    self.merchantId = methodData["merchantId"] as! String;
    self.supportedNetworks = methodData["supportedNetworks"] as! Array<String>;
  }
}


struct Payer {
  var firstName: String
  var lastName: String
  var middleName: String
  var birthDay: String
  var address: String
  var street: String
  var city: String
  var country: String
  var phone: String
  var postcode: String

  init(methodData: Dictionary<String, String>) {
    self.firstName = methodData["firstName"] ?? ""
    self.lastName = methodData["lastName"] ?? ""
    self.middleName = methodData["middleName"] ?? ""
    self.birthDay = methodData["birthDay"] ?? ""
    self.address = methodData["address"] ?? ""
    self.street = methodData["street"] ?? ""
    self.city = methodData["city"] ?? ""
    self.country = methodData["country"] ?? ""
    self.phone = methodData["phone"] ?? ""
    self.postcode = methodData["postcode"] ?? ""
  }
}


struct DataRecurrent {
  var interval: String
  var period: Int
  var amount: Int
  var startDate: String
  var maxPeriods: Int

  init(data: Dictionary<String, Any>) {
    self.interval = data["interval"] as! String
    self.period = data["period"] as! Int
    self.amount = data["amount"] as! Int
    self.startDate = data["startDate"] as! String
    self.maxPeriods = data["maxPeriods"] as! Int
  }
}

struct ReceiptItem {
  var label: String
  var price: Double
  var quantity: Double
  var amount: Double
  var vat: Int
  var method: Int
  var objectt: Int
  
  init(data: Dictionary<String, Any>) {
    self.label = data["label"] as! String
    self.price = data["price"] as! Double
    self.quantity = data["quantity"] as! Double
    self.amount = data["amount"] as! Double
    self.vat = data["vat"] as! Int
    self.method = data["method"] as! Int
    self.objectt = data["objectt"] as! Int
  }
}

struct ReceiptAmounts {
  var electronic: Double
  var advancePayment: Double
  var credit: Double
  var provision: Double

  init(data: Dictionary<String, Any>) {
    self.electronic = data["electronic"] as! Double
    self.advancePayment = data["advancePayment"] as! Double
    self.credit = data["credit"] as! Double
    self.provision = data["provision"] as! Double
  }
}

struct DataPaymentReceipt {
  var taxationSystem: Int
  var email: String
  var phone: String
  var isBso: Bool
  
  init(data: Dictionary<String, Any>) {
    self.taxationSystem = data["taxationSystem"] as! Int
    self.email = data["email"] as! String
    self.phone = data["phone"] as! String
    self.isBso = data["isBso"] as! Bool
  }
}

struct DageOfPayment {
  var amount: String
  var currency: String
  var accountId: String?
  var description: String?
  var email: String?
  var invoiceId: String?
  
  init(data: Dictionary<String, Any>) {
    self.amount = data["amount"] as! String
    self.currency = data["currency"] as! String
    self.accountId = data["accountId"] as? String
    self.description = data["description"] as? String
    self.email = data["email"] as? String
    self.invoiceId = data["invoiceId"] as? String
  }
}

struct ConfigurationPaymentForm {
  var publicId: String
  var requireEmail: Bool
  var useDualMessagePayment: Bool
  var showResultScreenForSinglePaymentMode: Bool
  var saveCardForSinglePaymentMode: Bool
  var testMode: Bool
  var mode: String
  
  init(data: Dictionary<String, Any>) {
    self.publicId = data["publicId"] as! String
    self.requireEmail = data["requireEmail"] as! Bool
    self.useDualMessagePayment = data["useDualMessagePayment"] as! Bool
    self.showResultScreenForSinglePaymentMode = data["showResultScreenForSinglePaymentMode"] as! Bool
    self.saveCardForSinglePaymentMode = data["saveCardForSinglePaymentMode"] as! Bool
    self.testMode = data["testMode"] as! Bool
    self.mode = data["mode"] as! String
  }
}
