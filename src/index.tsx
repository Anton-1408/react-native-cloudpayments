import { NativeModules } from 'react-native';

type CloudpaymentsType = {
  multiply(a: number, b: number): Promise<number>;
};

const { Cloudpayments } = NativeModules;

export default Cloudpayments as CloudpaymentsType;
