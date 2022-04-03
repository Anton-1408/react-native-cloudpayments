# CloudPayments SDK for React Native

Всем привет! Мы - [Purrweb](https://www.purrweb.com/ru/), однажды, заказчик крупного проекта [EnerGO](https://energo.app/) захотел перейти на платежную систему Cloud Payments, но, к сожалению, официальной библиотеки под React Native не оказалось, и нашему разработчику пришлось самому ее пилить. Сегодня мы хотим поделится с вами данной разработкой, поэтому ставьте звезды и пишите issues, мы постараемся поддерживать данный пакет.

CloudPayments SDK позволяет интегрировать прием платежей в мобильные приложение.

## Требования:

1. Для работы CloudPayments SDK необходим iOS версии 11.0 и выше.
2. Для работы CloudPayments SDK необходим Android версии 4.4 или выше (API level 19)

## Установка

```sh
yarn add react-native-cloudpayments-sdk
```

или

```sh
npm install react-native-cloudpayments-sdk
```

### Android

* Чтобы включить Google Pay в приложении, добавьте следующие метаданные в тег <application> файла AndroidManifest.xml.

```xml
<meta-data
  android:name="com.google.android.gms.wallet.api.enabled"
  android:value="true" />
```

* Чтобы использовать экран для подтверждения оплаты, добавьте activity в тег <application> файла AndroidManifest.xml.

```xml
<activity
  android:name="com.reactnativecloudpayments.ThreeDSecureActivity"
/>
```

* В файле `/android/build.gradle` в разделе `allprojects -> repositories` добавьте `jcenter()`

* Убедитесь, что дебажная версия приложения подписана релизным ключом, чтобы тестировать Google Pay в режиме Production.

#### Документации по интеграции Google Pay

[О Google Pay](https://developers.cloudpayments.ru/#google-pay)

[Документация](https://developers.google.com/pay/api/android/guides/setup)

[Официальный репозиторий SDK](https://github.com/cloudpayments/CloudPayments-SDK-Android)

### IOS

* Добавьте в `ios/Podfile`

```
pod 'Cloudpayments', :git =>  "https://github.com/cloudpayments/CloudPayments-SDK-iOS", :branch => "master"

pod 'CloudpaymentsNetworking', :git =>  "https://github.com/cloudpayments/CloudPayments-SDK-iOS", :branch => "master"

pod 'CardIO'
```

* Выполните `pod install` в папке ios

Для использования технологии Apple Pay вам необходимо зарегистрировать Merchant ID, сформировать платежный сертификат, сертификат для веб-платежей и подтвердить владение доменами сайтов, на которых будет производиться оплата.

#### Документации по интеграции Apple Pay

[О Apple Pay](https://developers.cloudpayments.ru/#apple-pay)

[Официальный репозиторий SDK](https://github.com/cloudpayments/CloudPayments-SDK-iOS)


## Использвание

```js
import { Card } from "react-native-cloudpayments-sdk";
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
const cardType = await Card.cardType(cardNumber);
```

* Определение банка эмитента

```js
const { bankName, logoUrl } = await Card.getBinInfo(cardNumber, merchantId);
```

* Шифрование карточных данных и создание криптограммы для отправки на сервер

```js
const cryptogramPacket = await Card.makeCardCryptogramPacket({
  cardNumber,
  expDate,
  cvv,
  merchantId,
});
```

* Шифрование cvv при оплате сохраненной картой и создание криптограммы для отправки на сервер

```js
const cryptogramPacket = await Card.makeCardCryptogramPacket({
  cvv,
});
```

* Отображение 3DS формы и получении результата 3DS аутентификации

```js
const { TransactionId, PaRes } = await Card.requestThreeDSecure({
  transactionId,
  paReq,
  acsUrl
})
```

Смотрите документацию по API: Платёж - [обработка 3-D Secure](https://developers.cloudpayments.ru/#obrabotka-3-d-secure)

#### Использование стандартной платежной формы Cloudpayments:

```js
import { CreditCardForm } from "react-native-cloudpayments-sdk";
```

* Инициализация

```js
const PAYMENT_DATA_CARD = {
  publicId: 'publicId',
  totalAmount: '10',
  currency: Currency.ruble,
  accountId: '1202',
  applePayMerchantId: 'merchant',
  description: 'Test',
  ipAddress: '8.8.8.8',
  invoiceId: '123',
  cardHolderName: 'Votinov Anton',
};

const PAYMENT_JSON_DATA_CARD = {
  age: '24',
  name: 'Anton',
  phone: '+7912343569',
};

CreditCardForm.initialPaymentData(
  PAYMENT_DATA_CARD,
  PAYMENT_JSON_DATA_CARD
);
```

* Вызов формы оплаты.

```js
const result = await CreditCardForm.showCreditCardForm({
  useDualMessagePayment: true,  // Использовать двухстадийную схему проведения платежа, по умолчанию используется одностадийная схема
  disableApplePay: true, // Выключить Apple Pay, по умолчанию Google Pay включен
  disableGPay: true, // Выключить Google Pay, по умолчанию Google Pay включен
});
```

#### Использование вашей платежной формы с использованием функций CloudpaymentsApi:
```js
import { CloudPaymentsApi } from "react-native-cloudpayments-sdk";
```

* Инициализация

```js
const PAYMENT_DATA_CARD = {
  publicId: 'publicId',
  totalAmount: '10',
  currency: Currency.ruble,
  accountId: '1202',
  applePayMerchantId: 'merchant',
  description: 'Test',
  ipAddress: '8.8.8.8',
  invoiceId: '123',
  cardHolderName: 'Votinov Anton',
};

const PAYMENT_JSON_DATA_CARD = {
  age: '24',
  name: 'Anton',
  phone: '+7912343569',
};

CloudPaymentsApi.initApi(PAYMENT_DATA_CARD, PAYMENT_JSON_DATA_CARD)
```

* Создайте криптограмму карточных данных

```js
const cryptogramPacket = await Card.makeCardCryptogramPacket({
  cardNumber,
  expDate,
  cvv,
  merchantId,
});
```

* Выполните запрос на проведения платежа. Создайте объект CloudpaymentApi и вызовите функцию charge для одностадийного платежа или auth для двухстадийного. Укажите email, на который будет выслана квитанция об оплате.

```js
const results = await CloudPaymentsApi.auth(cryptogramPacket, email)
```

```js
const results = await CloudPaymentsApi.charge(cryptogramPacket, email)
```

#### Использования Google Pay / Apple Pay

###### Поддержка типов платежных систем:
* Visa
* Master Card
* Discover
* Interac
* JCB (IOS 10.1+)
* MIR (только IOS 14.5+)

```js
import { PAYMENT_NETWORK, PaymentService } from "react-native-cloudpayments-sdk";
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
##### Примичание

`cloudpaymentsPublicID`: Ваш Public ID, его можно посмотреть в [личном кабинете](https://merchant.cloudpayments.ru/).

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

## Поддержка

По возникающим вопросам техничечкого характера и предложениями обращайтесь на antonvotinov@gmail.com

## License

MIT
