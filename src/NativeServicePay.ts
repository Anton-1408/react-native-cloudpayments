import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import type { EventEmitter } from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
  initialization: (
    data: MethodDataPayment,
    paymentNetworks: PAYMENT_NETWORK[]
  ) => void;
  setProducts: (price: string) => void;
  canMakePayments: () => Promise<boolean>;
  open: () => void;
  readonly onServicePayToken: EventEmitter<string>;
}

interface MethodDataPayment {
  merchantId: string;
  merchantName?: string;
  gateway?: {
    service: string;
    merchantId: string;
  };
  supportedNetworks: Array<string>;
  countryCode: string;
  currencyCode: string;
  environmentRunning?: number;
}

enum PAYMENT_NETWORK {
  visa = 'VISA',
  masterCard = 'MASTERCARD',
  amex = 'AMEX',
  discover = 'DISCOVER',
  interac = 'INTERAC',
  jcb = 'JCB',
  mir = 'MIR',
}

export default TurboModuleRegistry.getEnforcing<Spec>('ServicePay');
