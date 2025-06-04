import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  request: (params: RequestParams) => Promise<RequestResult>;
}

interface RequestParams {
  acsUrl: string;
  paReq: string;
  md: string;
}

interface RequestResult {
  md: string;
  paRes: string;
}

export default TurboModuleRegistry.getEnforcing<Spec>('ThreeDSecure');
