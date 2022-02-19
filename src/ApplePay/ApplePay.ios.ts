import { NativeModules, NativeEventEmitter } from 'react-native';
import { ListenerCryptogramCard, Product, MethodDataPayment } from '../types';

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
    ApplePayController.initialData(methodData);
  };

  public setProducts = (product: Product[]): void => {
    ApplePayController.setProducts(product);
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

export default ApplePay.getInstance();
