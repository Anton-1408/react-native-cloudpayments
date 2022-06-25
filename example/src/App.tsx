import React, { useEffect, useState } from 'react';
import {
  StyleSheet,
  View,
  TouchableOpacity,
  Text,
  Platform,
} from 'react-native';
import {
  PAYMENT_NETWORK,
  PaymentService,
  CreditCardForm,
  Currency,
} from 'react-native-cloudpayments-sdk';
import { PaymentServiceButton } from './components';

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

const PRODUCTS = [
  { name: 'example_1', price: '1' },
  { name: 'example_2', price: '10' },
  { name: 'example_3', price: '15' },
];

const PAYMENT_DATA_CARD = {
  publicId: 'publicId',
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

const paymentService = PaymentService.initial(PAYMENT_DATA);

const creditCardForm = CreditCardForm.initialPaymentData(
  PAYMENT_DATA_CARD,
  PAYMENT_JSON_DATA_CARD
);

const App = () => {
  const [isSupportPayments, setIsSupportPayments] = useState(false);

  useEffect(() => {
    paymentService.listenerCryptogramCard((cryptogram) => {
      console.warn(cryptogram);
    });

    getIsSupportPayments();

    return () => {
      paymentService.removeListenerCryptogramCard();
    };
  }, []);

  const getIsSupportPayments = async () => {
    const isMakePayments = await paymentService.canMakePayments();
    setIsSupportPayments(isMakePayments);
  };

  const onPayWithService = () => {
    paymentService.setProducts(PRODUCTS);

    paymentService.openServicePay();
  };

  const onPayWithCard = async () => {
    creditCardForm.setTotalAmount({
      currency: Currency.ruble,
      totalAmount: '100',
    });

    const result = await creditCardForm.showCreditCardForm({
      useDualMessagePayment: true,
      disableApplePay: false,
      disableGPay: false,
      disableYandexPay: false,
      yandexPayMerchantID: 'yandexPayMerchantID',
    });

    console.warn(result);
  };

  return (
    <View style={styles.container}>
      {isSupportPayments && <PaymentServiceButton onPay={onPayWithService} />}
      <TouchableOpacity style={styles.button} onPress={onPayWithCard}>
        <Text style={styles.title}>Card Form</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  button: {
    height: 50,
    width: 200,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#2962FF',
    borderRadius: 4,
    marginTop: 20,
  },
  title: {
    color: '#ffffff',
  },
});

export default App;
