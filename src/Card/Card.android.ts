import { NativeModules } from 'react-native';
import { Parametres3DS, Result3DS, BankInfo } from '../types';

const { Cloudpayments } = NativeModules;

class Card {
  private static instance: Card;
  private constructor() {}

  public static getInstance(): Card {
    if (!Card.instance) {
      Card.instance = new Card();
    }

    return Card.instance;
  }

  public isCardNumberValid = async (cardNumb: string): Promise<boolean> => {
    const isCardNumberValid: boolean = await Cloudpayments.isCardNumberValid(
      cardNumb
    );
    return isCardNumberValid;
  };

  public isExpDateValid = async (cardExpDate: string): Promise<boolean> => {
    const cardExpDateFormat = cardExpDate.replace('/', '');
    const isExpDateValid: boolean = await Cloudpayments.isExpDateValid(
      cardExpDateFormat
    );
    return isExpDateValid;
  };

  public cardCryptogramPacket = async (
    cardNumber: string,
    expDate: string,
    cvv: string,
    merchantId: string
  ): Promise<string> => {
    const expDateFormat = expDate.replace('/', '');
    const cardCryptogramPacket: string =
      await Cloudpayments.cardCryptogramPacket(
        cardNumber,
        expDateFormat,
        cvv,
        merchantId
      );
    return cardCryptogramPacket;
  };

  public getBinInfo = async (cardNumb: string): Promise<BankInfo> => {
    const binInfo: string = await Cloudpayments.getBinInfo(cardNumb);
    return JSON.parse(binInfo) as BankInfo;
  };

  public cardType = async (
    cardNumber: string,
    expDate: string,
    cvv: string
  ): Promise<string> => {
    const expDateFormat = expDate.replace('/', '');
    const cardType: string = await Cloudpayments.cardType(
      cardNumber,
      expDateFormat,
      cvv
    );
    return cardType;
  };

  public requestThreeDSecure = async (
    parametres3DS: Parametres3DS
  ): Promise<Result3DS> => {
    const result: string = await Cloudpayments.requestThreeDSecure(
      parametres3DS
    );
    return JSON.parse(result);
  };
}

export default Card.getInstance();
