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
    const jsonDataString = jsonData && JSON.stringify(jsonData);
    CreditCardFormManager.initialPaymentData(paymentData, jsonDataString);
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
    disableGPay,
    useDualMessagePayment,
  }: Configuration): Promise<number> => {
    const transactionId: number =
      await CreditCardFormManager.showCreditCardForm({
        disableGPay,
        useDualMessagePayment,
      });
    return transactionId;
  };
}

export default CreditCardForm;
