import PAYMENT_NETWORK from './PaymentNetwork';

export interface Parametres3DS {
  transactionId: string;
  paReq: string;
  acsUrl: string;
}
export interface Result3DS {
  TransactionId: string;
  PaRes: string;
}
export interface BankInfo {
  logoUrl: string;
  bankName: string;
}
export interface Product {
  name: string;
  price: string;
}
export interface MethodDataPayment {
  merchantId: string;
  merchantName?: string;
  gateway?: {
    service: string;
    merchantId: string;
  };
  supportedNetworks: Array<PAYMENT_NETWORK>;
  countryCode: string;
  currencyCode: string;
  environmentRunning?: EnvironmentRunningGooglePay;
}

export type EnvironmentRunningGooglePay = 'Test' | 'Production';

export type ListenerCryptogramCard = (cryptogram: string) => void;
