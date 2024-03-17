import { useEffect, useState } from 'react';
import NeoOrientationManager from './NeoOrientationManager';
import type { OrientationStatus } from './types';

const orientationManager = new NeoOrientationManager();

export const useNeoOrientation = () => {
  const [orientation, setOrientation] = useState<OrientationStatus>('unknown');
  useEffect(() => {
    const subscription = orientationManager.onOrientationChanged((o) => {
      console.log(`🐵 ------ o`, o);
      setOrientation(o);
    });
    return subscription.remove();
  });
  return orientation;
};
