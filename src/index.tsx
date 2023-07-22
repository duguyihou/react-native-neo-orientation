import { NativeModules, Platform } from 'react-native';

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

interface NeoOrientationInterface {
  lockToLandscape: () => void;
  lockToPortrait: () => void;
  lockToPortraitUpsideDown: () => void;
  lockToLandscapeRight: () => void;
  lockToLandscapeLeft: () => void;
  lockToAllOrientationButUpsideDown: () => void;
  unlockAllOrientations: () => void;
}

export default NeoOrientation as NeoOrientationInterface;
