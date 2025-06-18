# CloudPayments SDK for React Native

CloudPayments SDK позволяет интегрировать прием платежей для кроссплатформенных мобильных приложений на react-native.

## Поддержка нативных версий

1. Android: cloudpayments-android 1.7.1
2. IOS: cloudpayments-ios 1.5.18
3. Из-за различий версий между библиотеками, могут быть отличия в поддержке некоторого функционала

## Требования:

1. Для работы CloudPayments SDK необходим iOS версии 13.0 и выше.
2. Для работы CloudPayments SDK необходим Android версии 6.0 или выше (API level 23)
3. Добавлена поддержка JSI архитектуры react-native

## Установка

```sh
yarn add react-native-cloudpayments-sdk
```

или

```sh
npm install react-native-cloudpayments-sdk
```

### Android

- Чтобы включить Google Pay в приложении, добавьте следующие метаданные в тег `<application>` файла AndroidManifest.xml.

```xml
<meta-data
  android:name="com.google.android.gms.wallet.api.enabled"
  android:value="true" />
```

- Чтобы использовать экран для подтверждения оплаты, добавьте activity в тег `<application>` файла AndroidManifest.xml.

```xml
  <activity
    android:name="com.cloudpaymentssdk.ThreeDSecureActivity"
  />
```

- Убедитесь, что дебажная версия приложения подписана релизным ключом, чтобы тестировать Google Pay в режиме Production.

#### Документации по интеграции Google Pay

[О Google Pay](https://developers.cloudpayments.ru/#google-pay)

[Документация](https://developers.google.com/pay/api/android/guides/setup)

[Официальный репозиторий SDK](https://gitpub.cloudpayments.ru/integrations/sdk/cloudpayments-android)

### IOS

- Добавьте в `ios/Podfile`

```
  pod 'Cloudpayments', :git =>  "https://gitpub.cloudpayments.ru/integrations/sdk/cloudpayments-ios", :tag => '1.5.18'
  pod 'CloudpaymentsNetworking', :git =>  "https://gitpub.cloudpayments.ru/integrations/sdk/cloudpayments-ios", :tag => '1.5.18'

```

- Выполните `pod install` в папке ios

Для использования технологии Apple Pay вам необходимо зарегистрировать Merchant ID, сформировать платежный сертификат, сертификат для веб-платежей и подтвердить владение доменами сайтов, на которых будет производиться оплата.

#### Документации по интеграции Apple Pay

[О Apple Pay](https://developers.cloudpayments.ru/#apple-pay)

[Официальный репозиторий SDK](https://gitpub.cloudpayments.ru/integrations/sdk/cloudpayments-ios/-/tree/1.5.18?ref_type=tags)

## Использование

```js
import { CardService } from 'react-native-cloudpayments-sdk';
```

#### Возможности CloudPayments SDK:

- Проверка карточного номера на корректность

```js
const result = await CardService.isValidNumber(cardNumber);
```

- Проверка срока действия карты

```js
const result = await CardService.isValidExpDate(expDate); // expDate в формате MM/yy
```

- Проверка cvv карты

```js
const result = await CardService.isValidCvv(cvv);
```

- Определение типа платежной системы

```js
const cardType = await CardService.cardType(cardNumber);
```

- Определение банка эмитента

```js
const { bankName, cardType, convertedAmount, currency, hideCvv, logoUrl } =
  await CloudPaymentsAPI.getBinInfo(cardNumber);
```

- Шифрование карточных данных и создание криптограммы для отправки на сервер

```js
const cryptogramPacket = await CardService.createCardCryptogram(
  cardNumber,
  cardDate,
  cardCVC,
  publicId,
  publicKey
);
```

- Шифрование cvv при оплате сохраненной картой и создание криптограммы для отправки на сервер

```js
const cryptogramPacket = await CardService.cardCryptogramForCVV({
  cvv,
});
```

- Отображение 3DS формы и получении результата 3DS аутентификации

```js
const { TransactionId, PaRes } = await ThreeDSecure.request({
  acsUrl,
  md,
  paReq,
});
```

Смотрите документацию по API: Платёж - [обработка 3-D Secure](https://developers.cloudpayments.ru/#obrabotka-3-d-secure)

#### Использование стандартной платежной формы Cloudpayments:

```js
import { PaymentForm } from 'react-native-cloudpayments-sdk';
```

- Доп. поле, куда передается информация о плательщике

```js
PaymentForm.createPayer({
  address: '13',
  birthDay: '15.08.1998',
  city: 'Moscow',
  country: 'Russia',
  firstName: 'Anton',
  middleName: 'Alexandrovich',
  lastName: 'Votinov',
  phone: '89999999999',
  postcode: 'RU',
  street: 'Lenina',
});
```

- Создание чека

```js
PaymentForm.createDataReceipt(
  [
    {
      label: 'description',
      price: 300.0,
      quantity: 3.0,
      amount: 900.0,
      vat: 20,
      method: 0,
      objectt: 0,
    },
  ],
  {
    electronic: 900.0,
    advancePayment: 0.0,
    credit: 0.0,
    provision: 0.0,
  },
  {
    taxationSystem: 0,
    email: 'email',
    phone: 'payerPhone',
    isBso: false,
  }
);
```

- Создание объекта подписки

```js
PaymentForm.createDataRecurrent({
  amount: 10,
  interval: '1',
  maxPeriods: 10,
  period: 10,
  startDate: '15.08.1998',
});
```

- Создание PaymentData

```js
PaymentForm.createPaymentData({
  amount: '10',
  currency: CURRENCY.RUBLE,
  accountId: 'test',
  description: 'test',
  email: 'test',
  invoiceId: 'test',
});
```

- Вызов формы оплаты.

```js
const result = await PaymentForm.open({
  useDualMessagePayment: true, // Использовать двухстадийную схему проведения платежа
  mode: 'SelectPaymentMethod', // вараинт формы
  publicId: '', // Ваш Public_id из личного кабинета
  requireEmail: true, // Обязателный email для проведения оплаты (по умолчанию false)
  saveCardForSinglePaymentMode: true, // Галочка для сохранения или не сохранения карты
  showResultScreenForSinglePaymentMode: true, // Показывать или нет экран с результатом оплаты
  testMode: true,
});
```

#### Использование вашей платежной формы с использованием функций CloudpaymentsApi:

```js
import { CloudPaymentsAPI } from 'react-native-cloudpayments-sdk';
```

- Инициализация

```js
CloudPaymentsAPI.initialization(publicId);
```

- Получить публичный ключ

```js
CloudPaymentsAPI.getPublicKey();
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

ServicePay.initial(PAYMENT_DATA);
```

##### Примичание

`cloudpaymentsPublicID`: Ваш Public ID, его можно посмотреть в [личном кабинете](https://merchant.cloudpayments.ru/).

- Проверка, доступны ли пользователю эти платежные системы

```js
const isSupportPayments = await ServicePay.canMakePayments();
```

- Создайте массив покупок и передайте его в метод setProducts

```js
const PRODUCTS = [
  { name: 'example_1', price: '1' },
  { name: 'example_2', price: '10' },
  { name: 'example_3', price: '15' },
];

ServicePay.setProducts(PRODUCTS);
```

- Чтобы получить результат оплаты, нужно подписаться на listener

```js
useEffect(() => {
  const listenner = ServicePay.onServicePayToken((cryptogram) => {
    console.warn(cryptogram);
  });

  return () => {
    listenner.remove();
  };
}, []);
```

- Выполните оплату

```js
ServicePay.open();
```

## Автор

Вотинов Антон

## Поддержка

По возникающим вопросам техничечкого характера и предложениями обращайтесь на antonvotinov@gmail.com

## Дополнительная информация о библиотеки

[Первая версия библиотеки](https://github.com/PurrwebTeam/react-native-cloudpayments-v1) писалась для проекта [EnerGO](https://energo.app/), разработанным компанией [Purrweb](https://www.purrweb.com/ru/)

Спонсором новой версии библиотеки стала компания [Purrweb](https://www.purrweb.com/ru)

## License

MIT
