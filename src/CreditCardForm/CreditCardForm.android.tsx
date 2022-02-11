import { PaymentData, Configuration, PaymentJsonData } from '../types';

class CreditCardForm {
  private static instance: CreditCardForm;
  private constructor() {}

  public static getInstance(): CreditCardForm {
    if (!CreditCardForm.instance) {
      CreditCardForm.instance = new CreditCardForm();
    }

    return CreditCardForm.instance;
  }

  public initialPaymentData = (
    _paymentData: PaymentData,
    _jsonData?: PaymentJsonData
  ): void => {};

  public showCreditCardForm = (_configuration: Configuration): void => {};
}

export default CreditCardForm.getInstance();
