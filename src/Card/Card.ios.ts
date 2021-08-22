import { NativeModules } from 'react-native';
import { Parametres3DS, BankInfo, Result3DS } from '../types';

const { Cloudpayments, ThreeDSecure } = NativeModules;

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
    const isExpDateValid: boolean = await Cloudpayments.isExpDateValid(
      cardExpDate
    );
    return isExpDateValid;
  };

  public cardCryptogramPacket = async (
    cardNumber: string,
    expDate: string,
    cvv: string,
    merchantId: string
  ): Promise<string> => {
    const cardCryptogramPacket: string =
      await Cloudpayments.cardCryptogramPacket(
        cardNumber,
        expDate,
        cvv,
        merchantId
      );
    return cardCryptogramPacket;
  };

  public cardType = async (cardNumber: string): Promise<string> => {
    const cardType: string = await Cloudpayments.cardType(cardNumber);
    return cardType;
  };

  public getBinInfo = async (cardNumb: string): Promise<BankInfo> => {
    const binInfo = await Cloudpayments.getBinInfo(cardNumb);
    return binInfo;
  };

  public requestThreeDSecure = async (
    parametres3DS: Parametres3DS
  ): Promise<Result3DS> => {
    const result = await ThreeDSecure.requestThreeDSecure(parametres3DS);
    return result;
  };
}

export default Card.getInstance();
