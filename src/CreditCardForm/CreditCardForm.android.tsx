import {
  PaymentData,
  Configuration,
  PaymentJsonData,
  TotalAmount,
} from '../types';
import { NativeModules } from 'react-native';

const { CreditCardForm: CreditCardFormManager } = NativeModules;

class CreditCardForm {
  private static instance: CreditCardForm;

  private constructor(paymentData: PaymentData, jsonData?: PaymentJsonData) {
    CreditCardForm.saveInitialPaymentData(paymentData, jsonData)
  }

  public static initialPaymentData(
    paymentData: PaymentData,
    jsonData?: PaymentJsonData
  ): CreditCardForm {
    if (!CreditCardForm.instance) {
      CreditCardForm.instance = new CreditCardForm(paymentData, jsonData);
    }
    // Saving passed initial data
    CreditCardForm.saveInitialPaymentData(paymentData, jsonData)
    return CreditCardForm.instance;
  }

  public setTotalAmount({ totalAmount, currency }: TotalAmount): void {
    CreditCardFormManager.setTotalAmount(totalAmount, currency);
  }

  public showCreditCardForm = async ({
    disableGPay,
    useDualMessagePayment,
    disableYandexPay,
    yandexPayMerchantID,
  }: Configuration): Promise<number> => {
    const transactionId: number =
      await CreditCardFormManager.showCreditCardForm({
        disableGPay,
        useDualMessagePayment,
        disableYandexPay,
        yandexPayMerchantID,
      });
    return transactionId;
  };

  private static saveInitialPaymentData(paymentData: PaymentData, jsonData?: PaymentJsonData): void {
    const jsonDataString = jsonData && JSON.stringify(jsonData);
    CreditCardFormManager.initialPaymentData(paymentData, jsonDataString);
  }
}

export default CreditCardForm;
