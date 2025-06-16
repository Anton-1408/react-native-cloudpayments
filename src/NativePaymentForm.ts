import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  createPayer: (payer: Payer) => void;
  createDataReceipt: (
    receiptItems: Array<ReceiptItem>,
    receiptAmounts: ReceiptAmounts,
    dataPaymentReceipt: DataPaymentReceipt
  ) => void;
  createDataRecurrent: (dataRecurrent: DataRecurrent) => void;
  createPaymentData: (paymentData: PaymentData) => void;
  open: (caonfigurationData: ConfigurationPaymentForm) => Promise<string>;
}

interface Payer {
  firstName?: string;
  lastName?: string;
  middleName?: string;
  birthDay?: string;
  address?: string;
  street?: string;
  city?: string;
  country?: string;
  phone?: string;
  postcode?: string;
}

interface ReceiptAmounts {
  electronic: number;
  advancePayment: number;
  credit: number;
  provision: number;
}

interface DataPaymentReceipt {
  taxationSystem: number;
  email: string;
  phone: string;
  isBso: boolean;
}

interface ReceiptItem {
  label: string;
  price: number;
  quantity: number;
  amount: number;
  vat: number;
  method: number;
  objectt: number;
}

interface DataRecurrent {
  interval: string;
  period: number;
  maxPeriods: number;
  startDate: number;
  amount: number;
}

interface PaymentData {
  amount: string;
  currency: string;
  accountId?: string;
  description?: string;
  email?: string;
  applePayMerchantId?: string;
  invoiceId?: string;
}

interface ConfigurationPaymentForm {
  publicId: string;
  requireEmail: boolean;
  useDualMessagePayment: boolean;
  showResultScreenForSinglePaymentMode: boolean;
  saveCardForSinglePaymentMode: boolean;
  testMode: boolean;
  mode: 'SberPay' | 'SelectPaymentMethod' | 'SBP' | 'TPay';
  disableApplePay: boolean;
}

export default TurboModuleRegistry.getEnforcing<Spec>('PaymentForm');
