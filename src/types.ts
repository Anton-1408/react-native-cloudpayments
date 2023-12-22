import { Currency, PAYMENT_NETWORK } from './constants';

export interface Parametres3DS {
  transactionId: number;
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
  applePayMerchantId?: string;
  googlePayMerchantId?: string;
  yandexPayMerchantID?: string;
  ipAddress?: string;
  accountId?: string;
  cardHolderName?: string;
  cultureName?: string;
  payer?: Payer;
  jsonData?: string;
  email?: string;
  description?: string;
  invoiceId?: string;
  apiUrl?: string;
  amount?: string;
  currency?: Currency;
}

interface Payer {
  firstName?: String;
  lastName?: String;
  middleName?: String;
  birthDay?: String;
  address?: String;
  street?: String;
  city?: String;
  country?: String;
  phone?: String;
  postcode?: String;
}

export type PaymentDataApi = Omit<
  PaymentData,
  | 'applePayMerchantId'
  | 'googlePayMerchantId'
  | 'cultureName'
  | 'yandexPayMerchantID'
>;

export interface DetailsOfPayment {
  totalAmount: string;
  currency: Currency;
  invoiceId?: string;
  description?: string;
}

export interface PaymentJsonData {
  age?: string;
  name?: string;
  phone?: string;
}

export interface Configuration {
  useDualMessagePayment: boolean;
  disableApplePay?: boolean;
  disableGPay?: boolean;
  disableYandexPay?: boolean;
}

type EnvironmentRunningGooglePay = 'Test' | 'Production';

export type ListenerCryptogramCard = (cryptogram: string) => void;

export interface TransactionResponse {
  success?: boolean;
  message?: string;
  model?: Transaction;
}

interface Transaction {
  transactionId?: number;
  amount?: number;
  currency?: Currency;
  currencyCode?: number;
  invoiceId?: string;
  accountId?: string;
  email?: string;
  description?: string;
  authCode?: string;
  testMode?: boolean;
  ipAddress?: string;
  ipCountry?: string;
  ipCity?: string;
  ipRegion?: string;
  ipDistrict?: string;
  ipLatitude?: number;
  ipLongitude?: number;
  cardFirstSix?: string;
  cardLastFour?: string;
  cardExpDate?: string;
  cardType?: string;
  cardTypeCode?: number;
  issuer?: string;
  issuerBankCountry?: string;
  status?: string;
  statusCode?: number;
  reason?: string;
  reasonCode?: number;
  cardHolderMessage?: string;
  name?: string;
  paReq?: string;
  acsUrl?: string;
  threeDsCallbackId: string;
}

export interface CardInfo {
  cardNumber?: string;
  expDate?: string;
  cvv: string;
  merchantId?: string;
}

export interface CardCryptogram {
  cardNumber: string;
  cardExp: string;
  cardCvv: string;
  publicId: string;
  publicKey: string;
}
