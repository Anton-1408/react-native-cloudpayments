import { API_URL } from '../constants';
import {
  TransactionResponse,
  DetailsOfPayment,
  PaymentData,
  PaymentDataApi,
  PaymentJsonData,
} from '../types';
import { NativeModules } from 'react-native';

const { CloudPaymentsApi: CloudPaymentsApiManager } = NativeModules;

class CloudPaymentsApi {
  private static instance: CloudPaymentsApi;

  private constructor(paymentData: PaymentDataApi, jsonData?: PaymentJsonData) {
    CloudPaymentsApiManager.initApi(paymentData, jsonData);
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

  public reInitialization({ apiUrl = API_URL, ...rest }: PaymentData) {
    CloudPaymentsApiManager.initialization({ apiUrl, ...rest });
  }

  public setInformationAboutPaymentOfProduct(details: DetailsOfPayment): void {
    CloudPaymentsApiManager.setInformationAboutPaymentOfProduct(details);
  }

  public auth = async (
    cardCryptogramPacket: string,
    email?: string
  ): Promise<TransactionResponse> => {
    const result: string = await CloudPaymentsApiManager.auth(
      cardCryptogramPacket,
      email
    );
    return JSON.parse(result);
  };

  public charge = async (
    cardCryptogramPacket: string,
    email?: string
  ): Promise<TransactionResponse> => {
    const result: string = await CloudPaymentsApiManager.charge(
      cardCryptogramPacket,
      email
    );
    return JSON.parse(result);
  };
}

export default CloudPaymentsApi;
