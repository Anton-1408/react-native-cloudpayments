import { PaymentData, PaymentJsonData, TransactionResponse } from '../types';
import { NativeModules } from 'react-native';

const { CloudPaymentsApi: CloudPaymentsApiModule } = NativeModules;

class CloudPaymentsApi {
  private static instance: CloudPaymentsApi;
  private constructor() {}

  public static getInstance(): CloudPaymentsApi {
    if (!CloudPaymentsApi.instance) {
      CloudPaymentsApi.instance = new CloudPaymentsApi();
    }

    return CloudPaymentsApi.instance;
  }

  public initApi = (
    paymentData: PaymentData,
    jsonData?: PaymentJsonData
  ): void => {
    CloudPaymentsApiModule.initApi(paymentData, jsonData);
  };

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

export default CloudPaymentsApi.getInstance();
