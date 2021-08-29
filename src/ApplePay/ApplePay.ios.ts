import { NativeModules, NativeEventEmitter } from 'react-native';
import { ListenerCryptogramCard } from '../types';

const { EventEmitter } = NativeModules;

const eventCryptogramCard = new NativeEventEmitter(EventEmitter);

class ApplePay {
  private static instance: ApplePay;
  private constructor() {}

  public static getInstance(): ApplePay {
    if (!ApplePay.instance) {
      ApplePay.instance = new ApplePay();
    }

    return ApplePay.instance;
  }

  public listenerCryptogramCard = (callback: ListenerCryptogramCard) => {
    eventCryptogramCard.addListener('listenerCryptogramCard', callback);
  };

  public removeListenerCryptogramCard = (callback: ListenerCryptogramCard) => {
    eventCryptogramCard.removeListener('listenerCryptogramCard', callback);
  };
}

export default ApplePay.getInstance();
