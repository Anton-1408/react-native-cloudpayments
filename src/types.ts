import PAYMENT_NETWORK from './PaymentNetwork';
import Currency from './Currency';

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

export interface PaymentData {
  publicId: string;
  totalAmount: string;
  currency: Currency;
  accountId: string;
  applePayMerchantId: string;
  description?: string;
  ipAddress?: string;
  invoiceId?: string;
}

export interface PaymentJsonData {
  age?: string;
  name?: string;
  phone?: string;
}

export interface Configuration {
  useDualMessagePayment: boolean;
  disableApplePay: boolean;
}

export type EnvironmentRunningGooglePay = 'Test' | 'Production';

export type ListenerCryptogramCard = (cryptogram: string) => void;
