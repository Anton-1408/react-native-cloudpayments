import {
  PaymentDataApi,
  PaymentJsonData,
  TransactionResponse,
  DetailsOfPayment,
} from '../types';
import { NativeModules } from 'react-native';

const { CloudPaymentsApi: CloudPaymentsApiModule } = NativeModules;

class CloudPaymentsApi {
  private static instance: CloudPaymentsApi;

  private constructor(paymentData: PaymentDataApi, jsonData?: PaymentJsonData) {
    CloudPaymentsApiModule.initApi(paymentData, jsonData);
  }

  public static initialApi(
    {
      payer: _payer,
      jsonData: _json,
      email: _email,
      description: _description,
      invoiceId: _invoiceId,
      apiUrl: _apiUrl,
      amount: _amount,
      currency: _currency,
      ...rest
    }: PaymentDataApi,
    jsonData?: PaymentJsonData
  ): CloudPaymentsApi {
    if (!CloudPaymentsApi.instance) {
      CloudPaymentsApi.instance = new CloudPaymentsApi(rest, jsonData);
    }

    return CloudPaymentsApi.instance;
  }

  public setDetailsOfPayment(details: DetailsOfPayment): void {
    CloudPaymentsApiModule.setDetailsOfPayment(details);
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
