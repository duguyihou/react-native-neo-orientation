import { useEffect, useState } from 'react';
import NeoOrientationManager from './NeoOrientationManager';
import type { OrientationStatus } from './types';

const manager = new NeoOrientationManager();

export const useOrientation = () => {
  const [orientation, setOrientation] = useState<OrientationStatus>('unknown');
  useEffect(() => {
    const subscription = manager.onOrientationChanged((o) => {
      console.log(`🐵 ------ o`, o);
      setOrientation(o);
    });
    return subscription.remove();
  });
  return orientation;
};
