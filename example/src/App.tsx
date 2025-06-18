import { useEffect, useState } from 'react';
import {
  StyleSheet,
  View,
  TouchableOpacity,
  Text,
  Platform,
} from 'react-native';
import { PAYMENT_NETWORK, CURRENCY } from 'react-native-cloudpayments-sdk';
import {
  PaymentForm,
  ServicePay,
  CardService,
  ThreeDSecure,
} from 'react-native-cloudpayments-sdk';
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
      mode: 'SelectPaymentMethod',
      publicId: '',
      requireEmail: true,
      saveCardForSinglePaymentMode: true,
      showResultScreenForSinglePaymentMode: true,
      testMode: true,
    });

    console.warn(result);
  };

  const onCardService = async () => {
    try {
      const cardType = await CardService.cardType('4242424242424242');
      // const result = await CardService.isValidNumber('4242424242424242');
      // const result = await CardService.isValidCvv('424');
      // const result = await CardService.isValidExpDate('02/12');
      // const result = await CardService.cardCryptogramForCVV('333');
      // const result = await CardService.createCardCryptogram(
      //   '4242424242424242',
      //   '12/25',
      //   '333',
      //   'test',
      //   'test'
      // );
      const result = await ThreeDSecure.request({
        acsUrl: 'https://demo.cloudpayments.ru/acs',
        md: '891463508',
        paReq:
          '+/eyJNZXJjaGFudE5hbWUiOm51bGwsIkZpcnN0U2l4IjoiNDI0MjQyIiwiTGFzdEZvdXIiOiI0MjQyIiwiQW1vdW50IjoxMDAuMCwiQ3VycmVuY3lDb2RlIjoiUlVCIiwiRGF0ZSI6IjIwMjEtMTAtMjVUMDA6MDA6MDArMDM6MDAiLCJDdXN0b21lck5hbWUiOm51bGwsIkN1bHR1cmVOYW1lIjoicnUtUlUifQ==',
      });

      console.warn('here', result);
      console.warn('here', cardType);
    } catch (err) {
      console.warn('error', err);
    }
  };

  return (
    <View style={styles.container}>
      {isSupportPayments && <PaymentServiceButton onPay={onPayWithService} />}
      <TouchableOpacity style={styles.button} onPress={onPayWithCard}>
        <Text style={styles.title}>Card Form</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.button} onPress={onCardService}>
        <Text style={styles.title}>Card Service</Text>
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
