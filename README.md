# react-native-cloudpayments

CloudPayments SDK fro React Native

## Installation

```sh
npm install react-native-cloudpayments
yarn add react-native-cloudpayments
```

## Usage

```js
import { PAYMENT_NETWORK, PaymentService, Card }from "react-native-cloudpayments";
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

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
