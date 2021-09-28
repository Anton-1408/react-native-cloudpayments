import { NativeModules, NativeEventEmitter } from 'react-native';
import { ListenerCryptogramCard, Product } from '../types';
import PAYMENT_NETWORK from '../PaymentNetwork';

const { EventEmitter, ApplePayController } = NativeModules;

const eventCryptogramCard = new NativeEventEmitter(EventEmitter);

class ApplePay {
  private static instance: ApplePay;
  private constructor() {}

  public static getInstance(): ApplePay {
    if (!ApplePay.instance) {
      ApplePay.instance = new ApplePay();
    }

    return ApplePay.instance;
  }

  public initial = (methodData: MethodDataPayment): void => {
    this.setPaymentNetworks(methodData.supportedNetworks);
    this.setRequestPay(
      methodData.countryCode,
      methodData.currencyCode,
      methodData.merchantId
    );
  };

  public setProducts = (product: Product[]): void => {
    ApplePayController.setProducts(product);
  };

  private setPaymentNetworks = (
    paymentNetworks: Array<PAYMENT_NETWORK>
  ): void => {
    ApplePayController.setPaymentNetworks(paymentNetworks);
  };

  private setRequestPay = async (
    countryCode: string,
    currencyCode: string,
    merchantId: string
  ) => {
    ApplePayController.setRequestPay(countryCode, currencyCode, merchantId);
  };

  public canMakePayments = async (): Promise<boolean> => {
    const isCanMakePayments: boolean =
      await ApplePayController.canMakePayments();
    return isCanMakePayments;
  };

  public openServicePay = (): void => {
    ApplePayController.openApplePay();
  };

  public listenerCryptogramCard = (callback: ListenerCryptogramCard): void => {
    eventCryptogramCard.addListener('listenerCryptogramCard', callback);
  };

  public removeListenerCryptogramCard = (): void => {
    eventCryptogramCard.removeAllListeners('listenerCryptogramCard');
  };
}

interface MethodDataPayment {
  merchantId: string;
  supportedNetworks: Array<PAYMENT_NETWORK>;
  countryCode: string;
  currencyCode: string;
}

export default ApplePay.getInstance();
