import { useEffect, useState } from 'react';
import {
  StyleSheet,
  View,
  TouchableOpacity,
  Text,
  Platform,
} from 'react-native';
import { PAYMENT_NETWORK, CURRENCY } from 'react-native-cloudpayments-sdk';
import { PaymentForm, ServicePay } from 'react-native-cloudpayments-sdk';
import { PaymentServiceButton } from './components';

const PAYMENT_DATA = Platform.select({
  ios: () => {
    return {
      merchantId: 'applePayMerchantID',
      supportedNetworks: [
        PAYMENT_NETWORK.MASTERCARD,
        PAYMENT_NETWORK.VISA,
        PAYMENT_NETWORK.AMEX,
        PAYMENT_NETWORK.INTERAC,
        PAYMENT_NETWORK.DISCOVER,
        PAYMENT_NETWORK.MIR,
        PAYMENT_NETWORK.JCB,
      ],
      countryCode: 'RU',
      currencyCode: CURRENCY.RUBLE,
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
        PAYMENT_NETWORK.MASTERCARD,
        PAYMENT_NETWORK.VISA,
        PAYMENT_NETWORK.AMEX,
        PAYMENT_NETWORK.INTERAC,
        PAYMENT_NETWORK.DISCOVER,
        PAYMENT_NETWORK.JCB,
      ],
      countryCode: 'RU',
      currencyCode: CURRENCY.RUBLE,
      environmentRunning: 'Test',
    };
  },
})!();

const PRODUCTS = [
  { name: 'example_1', price: '1' },
  { name: 'example_2', price: '10' },
  { name: 'example_3', price: '15' },
];

const App = () => {
  const [isSupportPayments, setIsSupportPayments] = useState(false);

  useEffect(() => {
    ServicePay.initialization(PAYMENT_DATA);

    PaymentForm.createPayer({
      address: '13',
      birthDay: '15.08.1998',
      city: 'Moscow',
      country: 'Russia',
      firstName: 'Test',
      middleName: 'Testovich',
      lastName: 'Testov',
      phone: '89999999999',
      postcode: 'RU',
      street: 'Lenina',
    });

    PaymentForm.createDataRecurrent({
      amount: 10,
      interval: '1',
      maxPeriods: 10,
      period: 10,
      startDate: '15.08.1998',
    });

    PaymentForm.createPaymentData({
      amount: '10',
      currency: CURRENCY.RUBLE,
      accountId: 'test',
      description: 'test',
      email: 'test',
      invoiceId: 'test',
    });

    const listenner = ServicePay.onServicePayToken((cryptogram) => {
      console.warn(cryptogram);
    });

    getIsSupportPayments();

    return () => {
      listenner.remove();
    };
  }, []);

  const getIsSupportPayments = async () => {
    const isMakePayments = await ServicePay.canMakePayments();

    setIsSupportPayments(isMakePayments);
  };

  const onPayWithService = () => {
    ServicePay.setProducts(PRODUCTS);
    ServicePay.open();
  };

  const onPayWithCard = async () => {
    const result = await PaymentForm.open({
      useDualMessagePayment: true,
      mode: 'SBP',
      publicId: '',
      requireEmail: true,
      saveCardForSinglePaymentMode: true,
      showResultScreenForSinglePaymentMode: true,
      testMode: true,
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
