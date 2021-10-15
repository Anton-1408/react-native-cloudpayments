# react-native-cloudpayments

CloudPayments SDK fro React Native

## Installation

```sh
npm install react-native-cloudpayments
yarn add react-native-cloudpayments
```

## Usage

```js
import { Card } from "react-native-cloudpayments";
```
#### Возможности CloudPayments SDK:

* Проверка карточного номера на корректность

```js
const isCardNumber = await Card.isCardNumberValid(cardNumber);
```

* Проверка срока действия карты

```js
const isExpDate = await Card.isExpDateValid(expDate); // expDate в формате MM/yy
```

* Определение типа платежной системы

```js
const cardType = await Card.cardType(cardNumber, expDate, cvv);
```

* Определение банка эмитента

```js
const { bankName, logoUrl } = await Card.getBinInfo(cardNumber);
```

* Шифрование карточных данных и создание криптограммы для отправки на сервер

```js
const cryptogramPacket = await Card.cardCryptogramPacket(
  cardNumber,
  expDate,
  cvv,
  merchantPublicID
);
```

* Отображение 3DS формы и получении результата 3DS аутентификации

```js
const { TransactionId, PaRes } = await Card.requestThreeDSecure({
  transactionId,
  paReq,
  acsUrl,
})
```
##### Использования Google Pay / Apple Pay

###### Поддержка типов платежных систем:
* Visa
* Master Card
* Discover
* Interac
* JCB (IOS +10.1)
* MIR (только IOS +14.5)

```js
import { PAYMENT_NETWORK, PaymentService } from "react-native-cloudpayments";
```
* Инициализация

```js
const PAYMENT_DATA = Platform.select({
  ios: () => {
    return {
      merchantId: 'applePayMerchantID',
      supportedNetworks: [
        PAYMENT_NETWORK.masterCard,
        PAYMENT_NETWORK.visa,
        PAYMENT_NETWORK.amex,
        PAYMENT_NETWORK.interac,
        PAYMENT_NETWORK.discover,
        PAYMENT_NETWORK.mir,
        PAYMENT_NETWORK.jcb,
      ],
      countryCode: 'RU',
      currencyCode: 'RUB',
    };
  },
  android: () => {
    return {
      merchantId: 'googlePayMerchantID',
      merchantName: 'Example',
      gateway: {
        service: 'cloudpayments',
        merchantId: 'cloudpaymentsPublicID',
      },
      supportedNetworks: [
        PAYMENT_NETWORK.masterCard,
        PAYMENT_NETWORK.visa,
        PAYMENT_NETWORK.amex,
        PAYMENT_NETWORK.interac,
        PAYMENT_NETWORK.discover,
        PAYMENT_NETWORK.jcb,
      ],
      countryCode: 'RU',
      currencyCode: 'RUB',
      environmentRunning: 'Test',
    };
  },
})!();

PaymentService.initial(PAYMENT_DATA);
```

* Проверка, доступны ли пользователю эти платежные системы

```js
const isSupportPayments = await PaymentService.canMakePayments();
```

* Создайте массив покупок и передайте его в метод setProducts

```js
const PRODUCTS = [
  { name: 'example_1', price: '1' },
  { name: 'example_2', price: '10' },
  { name: 'example_3', price: '15' },
];

PaymentService.setProducts(PRODUCTS);
```

* Чтобы получить результат оплаты, нужно подписаться на listener

```js
useEffect(() => {
  PaymentService.listenerCryptogramCard((cryptogram) => {
    console.warn(cryptogram);
  });

  return () => {
    PaymentService.removeListenerCryptogramCard();
  };
}, []);
```

* Выполните оплату

```js
PaymentService.openServicePay();
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
