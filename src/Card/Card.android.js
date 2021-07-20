import { NativeModules } from 'react-native';

const { Cloudpayments } = NativeModules;

class Card {
  static instance;
  constructor() {}

  static getInstance() {
    if (!Card.instance) {
      this.instance = new Card();
    }

    return Card.instance;
  }

  isCardNumberValid = async (cardNumb) => {
    const isCardNumberValid = await Cloudpayments.isCardNumberValid(cardNumb);
    return isCardNumberValid;
  };

  isExpDateValid = async (cardExpDate) => {
    const isExpDateValid = await Cloudpayments.isExpDateValid(cardExpDate);
    return isExpDateValid;
  };

  cardCryptogramPacket = async (cardNumber, expDate, cvv, merchantId) => {
    const cardCryptogramPacket = await Cloudpayments.cardCryptogramPacket(
      cardNumber,
      expDate,
      cvv,
      merchantId
    );
    return cardCryptogramPacket;
  };

  getBinInfo = async (cardNumb) => {
    const binInfo = await Cloudpayments.getBinInfo(cardNumb);
    return JSON.parse(binInfo);
  };

  cardType = async (cardNumber, expDate, cvv) => {
    const cardType = await Cloudpayments.cardType(cardNumber, expDate, cvv);
    return cardType;
  };

  requestThreeDSecure = async (parametres3DS) => {
    const result = await Cloudpayments.requestThreeDSecure(parametres3DS);
    return JSON.parse(result);
  };
}

export default Card.getInstance();
