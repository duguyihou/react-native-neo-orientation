import { NativeModules, Platform } from 'react-native';
import type { NeoOrientationAPI } from './types';

const LINKING_ERROR =
  `The package 'react-native-neo-orientation' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const NeoOrientation = NativeModules.NeoOrientation
  ? NativeModules.NeoOrientation
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export default NeoOrientation as NeoOrientationAPI;
