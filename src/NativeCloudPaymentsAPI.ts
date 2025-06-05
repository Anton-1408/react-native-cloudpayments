import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  getPublicKey: () => Promise<PublicKey>;
  getBinInfo: (cardNumber: string) => Promise<BinInfo>;
  initialization: (publicId: string) => void;
}

interface BinInfo {
  cardType: string;
  bankName: string;
  logoUrl: string;
  currency: string;
  convertedAmount: string;
  hideCvv: boolean;
}

interface PublicKey {
  pem: string;
  version: number;
}

export default TurboModuleRegistry.getEnforcing<Spec>('CloudPaymentsApi');
