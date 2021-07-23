import { NativeModules, DeviceEventEmitter } from 'react-native';
import PAYMENT_NETWORK from '../PaymentNetwork';
import { ListenerCryptogramCard, Product } from '../types';

const { GooglePay } = NativeModules;

class GooglePayModule {
  private static instance: GooglePayModule;
  private constructor() {}

  public static getInstance(): GooglePayModule {
    if (!GooglePayModule.instance) {
      GooglePayModule.instance = new GooglePayModule();
    }

    return GooglePayModule.instance;
  }

  public initial = (methodData: MethodDataPayment): void => {
    const { gateway } = methodData;

    this.setPaymentNetworks(methodData.supportedNetworks);
    this.setProducts(methodData.product);
    this.setGatewayTokenSpecification(gateway.service, gateway.merchantId);
    this.setRequestPay(
      methodData.countryCode,
      methodData.currencyCode,
      methodData.merchantName,
      methodData.merchantId
    );
  };

  private setProducts = (product: Product): void => {
    GooglePay.setProducts(product);
  };

  private setPaymentNetworks = (
    paymentNetworks: Array<PAYMENT_NETWORK>
  ): void => {
    GooglePay.setPaymentNetworks(paymentNetworks);
  };

  private setRequestPay = (
    countryCode: string,
    currencyCode: string,
    merchantName: string,
    merchantId: string
  ): void => {
    GooglePay.setRequestPay(
      countryCode,
      currencyCode,
      merchantName,
      merchantId
    );
  };

  private setGatewayTokenSpecification = (
    gateway: string,
    gatewayMerchantId: string
  ): void => {
    GooglePay.setGatewayTokenSpecification(gateway, gatewayMerchantId);
  };

  public canMakePayments = async (): Promise<boolean> => {
    const isCanMakePayments: any = await GooglePay.canMakePayments();
    return isCanMakePayments;
  };

  public openPayWindow = (): void => {
    GooglePay.showGooglePayWindow();
  };

  public listenerCryptogramCard = (callback: ListenerCryptogramCard): void => {
    DeviceEventEmitter.addListener('listenerCryptogramCard', callback);
  };

  public removeListenerCryptogramCard = (
    callback: ListenerCryptogramCard
  ): void => {
    DeviceEventEmitter.removeListener('listenerCryptogramCard', callback);
  };
}

interface MethodDataPayment {
  merchantId: string;
  merchantName: string;
  gateway: {
    service: string;
    merchantId: string;
  };
  supportedNetworks: Array<PAYMENT_NETWORK>;
  countryCode: string;
  currencyCode: string;
  product: Product;
}

export default GooglePayModule.getInstance();
