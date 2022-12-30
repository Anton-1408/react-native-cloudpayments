# CloudPayments SDK for React Native

CloudPayments SDK позволяет интегрировать прием платежей в мобильные приложение.

## Требования:

1. Для работы CloudPayments SDK необходим iOS версии 11.0 и выше.
2. Для работы CloudPayments SDK необходим Android версии 6.0 или выше, и следующие зависимости (API level 23)

   минимальные версии окружения:
   compileSdkVersion 31,
   build:gradle 3.6.0,
   ndkVersion 21.4.7075529

## Установка

```sh
yarn add react-native-cloudpayments-sdk
```

или

```sh
npm install react-native-cloudpayments-sdk
```

### Android

- добавьте Yandex Client ID, для Yandex Pay (если Yandex Pay не используется, добавльте пустое значение)

```gradlew
android {
    ...
    defaultConfig {
       ...
       manifestPlaceholders = [
               YANDEX_CLIENT_ID: ""
       ]
		...
   	}
   	...
}
```

- Чтобы включить Google Pay в приложении, добавьте следующие метаданные в тег <application> файла AndroidManifest.xml.

```xml
<meta-data
  android:name="com.google.android.gms.wallet.api.enabled"
  android:value="true" />
```

- Чтобы использовать экран для подтверждения оплаты, добавьте activity в тег <application> файла AndroidManifest.xml.

```xml
<activity
  android:name="com.reactnativecloudpayments.ThreeDSecureActivity"
/>
```

- В файле `/android/build.gradle` в разделе `allprojects -> repositories` добавьте `jcenter()`

- Убедитесь, что дебажная версия приложения подписана релизным ключом, чтобы тестировать Google Pay в режиме Production.

#### Документации по интеграции Google Pay

[О Google Pay](https://developers.cloudpayments.ru/#google-pay)

[Документация](https://developers.google.com/pay/api/android/guides/setup)

[Официальный репозиторий SDK](https://github.com/cloudpayments/CloudPayments-SDK-Android)

### IOS

- Добавьте в `ios/Podfile`

```
pod 'Cloudpayments', :git =>  "https://github.com/cloudpayments/CloudPayments-SDK-iOS", :tag => '1.1.9'
pod 'CloudpaymentsNetworking', :git =>  "https://github.com/cloudpayments/CloudPayments-SDK-iOS", :tag => '1.1.9'
```

- Выполните `pod install` в папке ios

- Yandex Pay для ios пока не доступен

Для использования технологии Apple Pay вам необходимо зарегистрировать Merchant ID, сформировать платежный сертификат, сертификат для веб-платежей и подтвердить владение доменами сайтов, на которых будет производиться оплата.

#### Документации по интеграции Apple Pay

[О Apple Pay](https://developers.cloudpayments.ru/#apple-pay)

[Официальный репозиторий SDK](https://github.com/cloudpayments/CloudPayments-SDK-iOS)

## Использвание

```js
import { Card } from 'react-native-cloudpayments-sdk';
```

#### Возможности CloudPayments SDK:

- Проверка карточного номера на корректность

```js
const isCardNumber = await Card.isCardNumberValid(cardNumber);
```

- Проверка срока действия карты

```js
const isExpDate = await Card.isExpDateValid(expDate); // expDate в формате MM/yy
```

- Определение типа платежной системы

```js
const cardType = await Card.cardType(cardNumber);
```

- Определение банка эмитента

```js
const { bankName, logoUrl } = await Card.getBinInfo(cardNumber, merchantId);
```

- Шифрование карточных данных и создание криптограммы для отправки на сервер

```js
const cryptogramPacket = await Card.makeCardCryptogramPacket({
  cardNumber,
  expDate,
  cvv,
  merchantId,
});
```

- Шифрование cvv при оплате сохраненной картой и создание криптограммы для отправки на сервер

```js
const cryptogramPacket = await Card.makeCardCryptogramPacket({
  cvv,
});
```

- Отображение 3DS формы и получении результата 3DS аутентификации

```js
const { TransactionId, PaRes } = await Card.requestThreeDSecure({
  transactionId,
  paReq,
  acsUrl,
});
```

Смотрите документацию по API: Платёж - [обработка 3-D Secure](https://developers.cloudpayments.ru/#obrabotka-3-d-secure)

#### Использование стандартной платежной формы Cloudpayments:

```js
import { CreditCardForm } from 'react-native-cloudpayments-sdk';
```

- Инициализация

```js
const PAYMENT_DATA_CARD = {
  publicId: 'publicId',
  accountId: '1202',
  applePayMerchantId: 'merchant',
  googlePayMerchantId: 'merchant',
  ipAddress: '8.8.8.8',
  cardHolderName: 'Votinov Anton',
  yandexPayMerchantID: 'yandexPayMerchantID',
};

const PAYMENT_JSON_DATA_CARD = {
  age: '24',
  name: 'Anton',
  phone: '+7912343569',
};

const creditCardForm = CreditCardForm.initialPaymentData(
  PAYMENT_DATA_CARD,
  PAYMENT_JSON_DATA_CARD
);
```

- Инициализация суммы оплаты.

```js
creditCardForm.setDetailsOfPayment({
  currency: Currency.ruble,
  totalAmount: '1000',
  invoiceId: '123',
  description: 'Test',
});
```

- Вызов формы оплаты.

```js
const result = await creditCardForm.showCreditCardForm({
  useDualMessagePayment: true, // Использовать двухстадийную схему проведения платежа
  disableApplePay: true, // Выключить Apple Pay
  disableGPay: true, // Выключить Google Pay
  disableYandexPay: false, // Выключить Yandex Pay,
});
```

#### Использование вашей платежной формы с использованием функций CloudpaymentsApi:

```js
import { CloudPaymentsApi } from 'react-native-cloudpayments-sdk';
```

- Инициализация

```js
const PAYMENT_DATA_CARD = {
  publicId: 'publicId',
  accountId: '1202',
  ipAddress: '8.8.8.8',
  cardHolderName: 'Votinov Anton',
};

const PAYMENT_JSON_DATA_CARD = {
  age: '24',
  name: 'Anton',
  phone: '+7912343569',
};

const cloudPaymentsApi = CloudPaymentsApi.initApi(
  PAYMENT_DATA_CARD,
  PAYMENT_JSON_DATA_CARD
);
```

- Инициализация суммы оплаты.

```js
cloudPaymentsApi.setDetailsOfPayment({
  currency: Currency.ruble,
  totalAmount: '1000',
  invoiceId: '123',
  description: 'Test',
});
```

- Создайте криптограмму карточных данных

```js
const cryptogramPacket = await Card.makeCardCryptogramPacket({
  cardNumber,
  expDate,
  cvv,
  merchantId,
});
```

- Выполните запрос на проведения платежа. Создайте объект CloudpaymentApi и вызовите функцию charge для одностадийного платежа или auth для двухстадийного. Укажите email, на который будет выслана квитанция об оплате.

```js
const results = await cloudPaymentsApi.auth(cryptogramPacket, email);
```

```js
const results = await cloudPaymentsApi.charge(cryptogramPacket, email);
```

#### Использования Google Pay / Apple Pay

###### Поддержка типов платежных систем:

- Visa
- Master Card
- Discover
- Interac
- JCB (IOS 10.1+)
- MIR (только IOS 14.5+)

```js
import {
  PAYMENT_NETWORK,
  PaymentService,
} from 'react-native-cloudpayments-sdk';
```

- Инициализация

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

const paymentService = PaymentService.initial(PAYMENT_DATA);
```

##### Примичание

`cloudpaymentsPublicID`: Ваш Public ID, его можно посмотреть в [личном кабинете](https://merchant.cloudpayments.ru/).

- Проверка, доступны ли пользователю эти платежные системы

```js
const isSupportPayments = await paymentService.canMakePayments();
```

- Создайте массив покупок и передайте его в метод setProducts

```js
const PRODUCTS = [
  { name: 'example_1', price: '1' },
  { name: 'example_2', price: '10' },
  { name: 'example_3', price: '15' },
];

paymentService.setProducts(PRODUCTS);
```

- Чтобы получить результат оплаты, нужно подписаться на listener

```js
useEffect(() => {
  paymentService.listenerCryptogramCard((cryptogram) => {
    console.warn(cryptogram);
  });

  return () => {
    paymentService.removeListenerCryptogramCard();
  };
}, []);
```

- Выполните оплату

```js
paymentService.openServicePay();
```

## Поддержка

По возникающим вопросам техничечкого характера и предложениями обращайтесь на antonvotinov@gmail.com

## License

MIT
