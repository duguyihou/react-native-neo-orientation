import { useEffect, useState } from 'react';
import NeoOrientationManager from './NeoOrientationManager';
import type { DeviceOrientationStatus } from './types';

const manager = new NeoOrientationManager();

export const useDeviceOrientation = () => {
  const [deviceOrientation, setDeviceOrientation] =
    useState<DeviceOrientationStatus>('unknown');
  useEffect(() => {
    const subscription = manager.onOrientationChanged((deviceOri) => {
      setDeviceOrientation(deviceOri);
    });
    return subscription.remove();
  });
  return deviceOrientation;
};
