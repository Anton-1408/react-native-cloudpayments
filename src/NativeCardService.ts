import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  cardType: (cardNumber: string) => Promise<string>;
  isValidNumber: (cardNumber: string) => Promise<boolean>;
  isValidExpDate: (expDate: string) => Promise<boolean>;
  createCardCryptogram: (
    cardNumber: string,
    cardDate: string,
    cardCVC: string,
    publicId: string,
    publicKey: string
  ) => Promise<string>;
  cardCryptogramForCVV: (cvv: string) => Promise<string>;
  isValidExpDateFull: (expDate: string) => Promise<boolean>;
  isValidCvv: (cvv: string) => Promise<boolean>;
  createHexPacketFromData: (
    cardNumber: string,
    cardExp: string,
    cardCvv: string,
    publicId: string,
    publicKey: string,
    keyVersion: number
  ) => Promise<string>;
  createMirPayHexPacketFromCryptogram: (cryptogram: string) => Promise<string>;
  getBinInfo: (cardNumber: string, merchantId: string) => Promise<BinInfo>;
}

interface BinInfo {
  cardType: string;
  bankName: string;
  logoUrl: string;
  currency: string;
  convertedAmount: string;
  hideCvv: boolean;
}

export default TurboModuleRegistry.getEnforcing<Spec>('CardService');
