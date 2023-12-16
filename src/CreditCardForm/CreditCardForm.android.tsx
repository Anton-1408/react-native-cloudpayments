import {
  PaymentData,
  Configuration,
  PaymentJsonData,
  DetailsOfPayment,
} from '../types';
import { NativeModules } from 'react-native';

const { PaymentForm: PaymentFormManager } = NativeModules;

class CreditCardForm {
  private static instance: CreditCardForm;

  private constructor(paymentData: PaymentData) {
    PaymentFormManager.initialization(paymentData);
  }

  public static initialPaymentData(
    paymentData: PaymentData,
    _jsonData: PaymentJsonData = {}
  ): CreditCardForm {
    if (!CreditCardForm.instance) {
      CreditCardForm.instance = new CreditCardForm(paymentData);
    }

    return CreditCardForm.instance;
  }

  public setDetailsOfPayment(details: DetailsOfPayment): void {
    PaymentFormManager.setInformationAboutPaymentOfProduct(details);
  }

  public showCreditCardForm = async ({
    useDualMessagePayment,
    disableGPay = true,
    disableYandexPay = true,
  }: Configuration): Promise<number> => {
    const transactionId: number = await PaymentFormManager.open({
      disableGPay,
      useDualMessagePayment,
      disableYandexPay,
    });
    return transactionId;
  };
}

export default CreditCardForm;
