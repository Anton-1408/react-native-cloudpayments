import {
  PaymentData,
  Configuration,
  PaymentJsonData,
  DetailsOfPayment,
} from '../types';
import { NativeModules } from 'react-native';

const { PaymentForm: PaymentFormManager } = NativeModules;

class PaymentForm {
  private static instance: PaymentForm;

  private constructor(paymentData: PaymentData) {
    PaymentFormManager.initialization(paymentData);
  }

  public static initialization(
    paymentData: PaymentData,
    _jsonData: PaymentJsonData = {}
  ): PaymentForm {
    if (!PaymentForm.instance) {
      PaymentForm.instance = new PaymentForm(paymentData);
    }

    return PaymentForm.instance;
  }

  public reInitialization(paymentData: PaymentData) {
    PaymentFormManager.initialization(paymentData);
  }

  public setInformationAboutPaymentOfProduct(details: DetailsOfPayment): void {
    PaymentFormManager.setInformationAboutPaymentOfProduct(details);
  }

  public open = async ({
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

export default PaymentForm;
