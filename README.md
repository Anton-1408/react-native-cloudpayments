# CloudPayments SDK for React Native

Всем привет! Мы [Purrweb](https://www.purrweb.com/ru/), однажды, заказчик крупного проекта [EnerGO](https://energo.app/) захотел перейти на платежную систему Cloud Payments, но, к сожалению, официальной библиотеки под React Native не оказалось, и нашему разработчику пришлось самому ее пилить. Сегодня мы хотим поделится с вами данной разработкой, поэтому ставьте звезды и пишите issues, мы постараемся поддерживать данный пакет.

CloudPayments SDK позволяет интегрировать прием платежей в мобильные приложение.

## Установка

```sh
npm install react-native-cloudpayments

yarn add react-native-cloudpayments
```

### Android

* Чтобы включить Google Pay в приложении, добавьте следующие метаданные в тег <application> файла AndroidManifest.xml.

```xml
<meta-data
  android:name="com.google.android.gms.wallet.api.enabled"
  android:value="true" />
```

* Чтобы использовать экран для подтверждения оплыты, добавьте activity в тег <application> файла AndroidManifest.xml.

```xml
<activity
  android:name="com.reactnativecloudpayments.ThreeDSecureActivity"
/>
```

##### Примичание
* Чтобы экран с подтверждением оплаты не закрывался после перехода приложения из фоного режима на передний план ([issues](https://issuetracker.google.com/issues/64108432)) добавьте в MainActivity.java следующие строки:

```java
import android.os.Bundle;
import android.content.Intent;

@Override
protected void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);

  if (!isTaskRoot()) {
    final Intent intent = getIntent();
    if (intent.hasCategory(Intent.CATEGORY_LAUNCHER) && Intent.ACTION_MAIN.equals(intent.getAction())) {
      finish();
      return;
    }
  }
}
```

и измените значение у `android:launchMode` на `singleTop` у MainActivity в AndroidManifest.xml.

* Убедитесь, что дебажная версия приложения подписана релизным ключом, чтобы тестировать Google Pay.

#### Документации по интеграции Google Pay

[О Google Pay](https://developers.cloudpayments.ru/#google-pay)

[Документация](https://developers.google.com/pay/api/android/guides/setup)

[Официальный репозиторий SDK](https://github.com/cloudpayments/SDK-Android)

### IOS

Для использования технологии Apple Pay вам необходимо зарегистрировать Merchant ID, сформировать платежный сертификат, сертификат для веб-платежей и подтвердить владение доменами сайтов, на которых будет производиться оплата.

#### Документации по интеграции Apple Pay

[О Apple Pay](https://developers.cloudpayments.ru/#apple-pay)

[Официальный репозиторий SDK](https://github.com/cloudpayments/SDK-iOS)


## Использвание

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

Смотрите документацию по API: Платёж - [обработка 3-D Secure](https://developers.cloudpayments.ru/#obrabotka-3-d-secure)

#### Использования Google Pay / Apple Pay

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
