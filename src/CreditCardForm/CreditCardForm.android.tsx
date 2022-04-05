import { PaymentData, Configuration, PaymentJsonData } from '../types';
import { NativeModules } from 'react-native';

const { CreditCardForm: CreditCardFormManager } = NativeModules;

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
    const jsonDataString = jsonData && JSON.stringify(jsonData);

    CreditCardFormManager.initialPaymentData(paymentData, jsonDataString);
  };

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

export default CreditCardForm.getInstance();
