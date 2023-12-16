import { NativeModules } from 'react-native';
import { PaymentData, Configuration, DetailsOfPayment } from '../types';
import { API_URL } from '../constants';

const { PaymentFormManager } = NativeModules;

class PaymentForm {
  private static instance: PaymentForm;

  private constructor({ apiUrl = API_URL, ...rest }: PaymentData) {
    PaymentFormManager.initialization({ apiUrl, ...rest });
  }

  public static initialization(paymentData: PaymentData): PaymentForm {
    if (!PaymentForm.instance) {
      PaymentForm.instance = new PaymentForm(paymentData);
    }

    return PaymentForm.instance;
  }

  public reInitialization({ apiUrl = API_URL, ...rest }: PaymentData) {
    PaymentFormManager.initialization({ apiUrl, ...rest });
  }

  public setInformationAboutPaymentOfProduct(details: DetailsOfPayment): void {
    PaymentFormManager.setInformationAboutPaymentOfProduct(details);
  }

  public open = async ({
    useDualMessagePayment,
    disableApplePay = true,
    disableYandexPay = true,
  }: Configuration): Promise<Number> => {
    const transactionId: number = await PaymentFormManager.showCreditCardForm({
      useDualMessagePayment,
      disableApplePay,
      disableYandexPay,
    });

    return transactionId;
  };
}

export default PaymentForm;
