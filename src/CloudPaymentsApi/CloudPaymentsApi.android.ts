import {
  PaymentData,
  PaymentJsonData,
  TransactionResponse,
  DetailsOfPayment,
} from '../types';
import { NativeModules } from 'react-native';

const { CloudPaymentsApi: CloudPaymentsApiModule } = NativeModules;

type PaymentDataParams = Omit<
  PaymentData,
  'applePayMerchantId' | 'googlePayMerchantId'
>;

class CloudPaymentsApi {
  private static instance: CloudPaymentsApi;

  private constructor(
    paymentData: PaymentDataParams,
    jsonData?: PaymentJsonData
  ) {
    const jsonDataString = jsonData && JSON.stringify(jsonData);

    CloudPaymentsApiModule.initApi(paymentData, jsonDataString);
  }

  public static initialApi(
    paymentData: PaymentDataParams,
    jsonData?: PaymentJsonData
  ): CloudPaymentsApi {
    if (!CloudPaymentsApi.instance) {
      CloudPaymentsApi.instance = new CloudPaymentsApi(paymentData, jsonData);
    }

    return CloudPaymentsApi.instance;
  }

  public setDetailsOfPayment(details: DetailsOfPayment): void {
    CloudPaymentsApiModule.setDetailsOfPayment(details);
  }

  public auth = async (
    cardCryptogramPacket: string,
    email: string
  ): Promise<TransactionResponse> => {
    const result: string = await CloudPaymentsApiModule.auth(
      cardCryptogramPacket,
      email
    );
    return JSON.parse(result);
  };

  public charge = async (
    cardCryptogramPacket: string,
    email: string
  ): Promise<TransactionResponse> => {
    const result: string = await CloudPaymentsApiModule.charge(
      cardCryptogramPacket,
      email
    );
    return JSON.parse(result);
  };
}

export default CloudPaymentsApi;
