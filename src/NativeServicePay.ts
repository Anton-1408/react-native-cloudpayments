import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import type { EventEmitter } from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
  initialization: (data: MethodDataPayment) => void;
  setProducts: (products: Product[]) => void;
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

export interface Product {
  name: string;
  price: string;
}

export default TurboModuleRegistry.getEnforcing<Spec>('ServicePay');
