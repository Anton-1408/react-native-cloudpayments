import { NativeModules } from 'react-native';
import {
  PaymentData,
  Configuration,
  PaymentJsonData,
  DetailsOfPayment,
} from '../types';

const { CreditCardFormManager } = NativeModules;

class CreditCardForm {
  private static instance: CreditCardForm;

  private constructor(paymentData: PaymentData, jsonData?: PaymentJsonData) {
    CreditCardFormManager.initialPaymentData(paymentData, jsonData);
  }

  public static initialPaymentData(
    {
      payer: _payer,
      jsonData: _json,
      email: _email,
      description: _description,
      invoiceId: _invoiceId,
      apiUrl: _apiUrl,
      amount: _amount,
      currency: _currency,
      ...rest
    }: PaymentData,
    jsonData: PaymentJsonData = {}
  ): CreditCardForm {
    if (!CreditCardForm.instance) {
      CreditCardForm.instance = new CreditCardForm(rest, jsonData);
    }

    return CreditCardForm.instance;
  }

  public setDetailsOfPayment(details: DetailsOfPayment): void {
    CreditCardFormManager.setDetailsOfPayment(details);
  }

  public showCreditCardForm = async ({
    useDualMessagePayment,
    disableApplePay = true,
    disableYandexPay = true,
  }: Configuration): Promise<Number> => {
    const transactionId: number =
      await CreditCardFormManager.showCreditCardForm({
        useDualMessagePayment,
        disableApplePay,
        disableYandexPay,
      });
    return transactionId;
  };
}

export default CreditCardForm;
