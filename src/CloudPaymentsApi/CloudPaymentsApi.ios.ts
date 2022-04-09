import {
  PaymentData,
  PaymentJsonData,
  TransactionResponse,
  TotalAmount,
} from '../types';
import { NativeModules } from 'react-native';

const { CloudPaymentsApi: CloudPaymentsApiModule } = NativeModules;

class CloudPaymentsApi {
  private static instance: CloudPaymentsApi;

  private constructor(paymentData: PaymentData, jsonData?: PaymentJsonData) {
    CloudPaymentsApiModule.initApi(paymentData, jsonData);
  }

  public static initialApi(
    paymentData: PaymentData,
    jsonData?: PaymentJsonData
  ): CloudPaymentsApi {
    if (!CloudPaymentsApi.instance) {
      CloudPaymentsApi.instance = new CloudPaymentsApi(paymentData, jsonData);
    }

    return CloudPaymentsApi.instance;
  }

  public setTotalAmount({ totalAmount, currency }: TotalAmount): void {
    CloudPaymentsApiModule.setTotalAmount(totalAmount, currency);
  }

  public auth = async (
    cardCryptogramPacket: string,
    email?: string
  ): Promise<TransactionResponse> => {
    const result: string = await CloudPaymentsApiModule.auth(
      cardCryptogramPacket,
      email
    );
    return JSON.parse(result);
  };

  public charge = async (
    cardCryptogramPacket: string,
    email?: string
  ): Promise<TransactionResponse> => {
    const result: string = await CloudPaymentsApiModule.charge(
      cardCryptogramPacket,
      email
    );
    return JSON.parse(result);
  };
}

export default CloudPaymentsApi;
