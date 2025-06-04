import { StyleSheet, View } from 'react-native';

import { PaymentServiceButton } from './components';

const App = () => {
  return (
    <View style={styles.container}>
      <PaymentServiceButton onPay={() => {}} />
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
