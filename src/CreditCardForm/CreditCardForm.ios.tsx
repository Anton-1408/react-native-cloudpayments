import { NativeModules } from 'react-native';
import {
  PaymentData,
  Configuration,
  PaymentJsonData,
  TotalAmount,
} from '../types';

const { CreditCardFormManager } = NativeModules;

class CreditCardForm {
  private static instance: CreditCardForm;

  private constructor(paymentData: PaymentData, jsonData?: PaymentJsonData) {
    CreditCardFormManager.initialPaymentData(paymentData, jsonData);
  }

  public static initialPaymentData(
    paymentData: PaymentData,
    jsonData?: PaymentJsonData
  ): CreditCardForm {
    if (!CreditCardForm.instance) {
      CreditCardForm.instance = new CreditCardForm(paymentData, jsonData);
    }

    return CreditCardForm.instance;
  }

  public setTotalAmount({ totalAmount, currency }: TotalAmount): void {
    CreditCardFormManager.setTotalAmount(totalAmount, currency);
  }

  public showCreditCardForm = async ({
    disableApplePay,
    useDualMessagePayment,
  }: Configuration): Promise<Number> => {
    const transactionId: number =
      await CreditCardFormManager.showCreditCardForm({
        useDualMessagePayment,
        disableApplePay,
      });
    return transactionId;
  };
}

export default CreditCardForm;
