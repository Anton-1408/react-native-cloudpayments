import { NativeModules, DeviceEventEmitter } from 'react-native';
import { ListenerCryptogramCard, Product, MethodDataPayment } from '../types';

const { GooglePayModule } = NativeModules;

class GooglePay {
  private static instance: GooglePay;
  private constructor() {}

  public static getInstance(): GooglePay {
    if (!GooglePay.instance) {
      GooglePay.instance = new GooglePay();
    }

    return GooglePay.instance;
  }

  public initial = ({
    supportedNetworks,
    ...rest
  }: MethodDataPayment): void => {
    const numberConstantEnvironment = rest.environmentRunning
      ? WalletConstants[rest.environmentRunning]
      : WalletConstants.Test;

    const initialData = {
      ...rest,
      environmentRunning: numberConstantEnvironment,
    };

    GooglePayModule.initial(initialData, supportedNetworks);
  };

  public setProducts = (product: Product[]): void => {
    const sumPrice = product.reduce((previousValue, currentValue) => {
      return previousValue + Number(currentValue.price);
    }, 0);
    GooglePayModule.setProducts(String(sumPrice));
  };

  public canMakePayments = async (): Promise<boolean> => {
    const isCanMakePayments: boolean = await GooglePayModule.canMakePayments();
    return isCanMakePayments;
  };

  public openServicePay = (): void => {
    GooglePayModule.openGooglePay();
  };

  public listenerCryptogramCard = (callback: ListenerCryptogramCard): void => {
    DeviceEventEmitter.addListener('listenerCryptogramCard', callback);
  };

  public removeListenerCryptogramCard = (): void => {
    DeviceEventEmitter.removeAllListeners('listenerCryptogramCard');
  };
}

enum WalletConstants {
  Test = 3,
  Production = 1,
}

export default GooglePay.getInstance();
