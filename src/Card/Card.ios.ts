import { NativeModules } from 'react-native';
import { Parametres3DS, BankInfo, Result3DS, CardInfo } from '../types';

const { CardService, ThreeDSecure } = NativeModules;

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
    const isCardNumberValid: boolean = await CardService.isCardNumberValid(
      cardNumb
    );
    return isCardNumberValid;
  };

  public isExpDateValid = async (cardExpDate: string): Promise<boolean> => {
    const isExpDateValid: boolean = await CardService.isExpDateValid(
      cardExpDate
    );
    return isExpDateValid;
  };

  public makeCardCryptogramPacket = async ({
    cardNumber,
    expDate,
    cvv,
    merchantId,
  }: CardInfo): Promise<string> => {
    if (cardNumber && expDate && merchantId) {
      return await CardService.makeCardCryptogramPacket(
        cardNumber,
        expDate,
        cvv,
        merchantId
      );
    }
    return await CardService.makeCardCryptogramPacketForCvv(cvv);
  };

  public cardType = async (cardNumber: string): Promise<string> => {
    const cardType: string = await CardService.cardType(cardNumber);
    return cardType;
  };

  public getBinInfo = async (
    cardNumb: string,
    _merchantId: string
  ): Promise<BankInfo> => {
    const binInfo: BankInfo = await CardService.getBinInfo(cardNumb);
    return binInfo;
  };

  public requestThreeDSecure = async (
    parametres3DS: Parametres3DS
  ): Promise<Result3DS> => {
    const transactionId = String(parametres3DS.transactionId);

    const result = await ThreeDSecure.requestThreeDSecure({
      ...parametres3DS,
      transactionId,
    });
    return result;
  };
}

export default Card.getInstance();
