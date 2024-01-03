import { NativeModules, DeviceEventEmitter } from 'react-native';
import { ListenerCryptogramCard, Product, MethodDataPayment } from '../types';

const { GooglePayModule } = NativeModules;

class GooglePay {
  private static instance: GooglePay;

  private constructor({
    supportedNetworks,
    environmentRunning = 'Test',
    ...rest
  }: MethodDataPayment) {
    const numberConstantEnvironment = WalletConstant[environmentRunning];
    const initialData = {
      ...rest,
      environmentRunning: numberConstantEnvironment,
    };

    GooglePayModule.initialization(initialData, supportedNetworks);
  }

  public static initial(initialData: MethodDataPayment): GooglePay {
    if (!GooglePay.instance) {
      GooglePay.instance = new GooglePay(initialData);
    }

    return GooglePay.instance;
  }

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
    GooglePayModule.open();
  };

  public listenerCryptogramCard = (callback: ListenerCryptogramCard): void => {
    DeviceEventEmitter.addListener('listenerCryptogramCard', callback);
  };

  public removeListenerCryptogramCard = (): void => {
    DeviceEventEmitter.removeAllListeners('listenerCryptogramCard');
  };
}

enum WalletConstant {
  Test = 3,
  Production = 1,
}

export default GooglePay;
