import { PaymentData, PaymentJsonData } from '../types';

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
    _publicId: string,
    _paymentData: PaymentData,
    _jsonData?: PaymentJsonData
  ): void => {};

  public auth = async (
    _cardCryptogramPacket: string,
    _email: string
  ): Promise<any> => {};

  public charge = async (
    _cardCryptogramPacket: string,
    _email: string
  ): Promise<any> => {};
}

export default CloudPaymentsApi.getInstance();
