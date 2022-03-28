import { NativeModules } from 'react-native';
import { PaymentData, Configuration, PaymentJsonData } from '../types';

const { CreditCardFormManager } = NativeModules;

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
    paymentData: PaymentData,
    jsonData?: PaymentJsonData
  ): void => {
    CreditCardFormManager.initialPaymentData(paymentData, jsonData);
  };

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

export default CreditCardForm.getInstance();
