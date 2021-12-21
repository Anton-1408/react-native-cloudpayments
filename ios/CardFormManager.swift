
@objc(CardFormComponent)
class CardFormManager: RCTViewManager {
  override
  static func requiresMainQueueSetup() -> Bool {
    return true;
  }
  
  override
  func view() -> UIView {
    let label = UILabel();
    label.text = "Pizdos";
    label.textAlignment = .center;
    label.textColor = .black;
    return label;
  }
}
