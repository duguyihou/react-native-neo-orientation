import { NativeEventEmitter, NativeModules } from 'react-native';
import type {
  DeviceOrientationStatus,
  LockStatus,
  OrientationStatus,
} from './types';

const { NeoOrientation: Native } = NativeModules;

class NeoOrientationManager {
  onOrientationChanged(listener: (status: OrientationStatus) => void) {
    const eventEmitter = new NativeEventEmitter(Native);
    return eventEmitter.addListener('orientationDidChange', listener);
  }
  onDeviceOrientationChanged(
    listener: (status: DeviceOrientationStatus) => void
  ) {
    const eventEmitter = new NativeEventEmitter(Native);
    return eventEmitter.addListener('deviceOrientationDidChange', listener);
  }
  onLockChanged(listener: (status: LockStatus) => void) {
    const eventEmitter = new NativeEventEmitter(Native);
    return eventEmitter.addListener('lockDidChange', listener);
  }
}

export default NeoOrientationManager;
