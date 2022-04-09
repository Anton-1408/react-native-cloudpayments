import { NativeModules, NativeEventEmitter } from 'react-native';
import { ListenerCryptogramCard, Product, MethodDataPayment } from '../types';

const { EventEmitter, ApplePayController } = NativeModules;

const eventCryptogramCard = new NativeEventEmitter(EventEmitter);

class ApplePay {
  private static instance: ApplePay;

  private constructor(methodData: MethodDataPayment) {
    ApplePayController.initialData(methodData);
  }

  public static initial(methodData: MethodDataPayment): ApplePay {
    if (!ApplePay.instance) {
      ApplePay.instance = new ApplePay(methodData);
    }

    return ApplePay.instance;
  }

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

export default ApplePay;
