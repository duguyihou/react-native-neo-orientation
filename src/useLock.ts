import { useEffect, useState } from 'react';
import NeoOrientationManager from './NeoOrientationManager';
import type { LockStatus } from './types';

const manager = new NeoOrientationManager();

export const useLock = () => {
  const [lock, setLock] = useState<LockStatus>(null);
  useEffect(() => {
    const subscription = manager.onLockChanged((l) => {
      console.log(`🐵 ------ l`, l);
      setLock(l);
    });
    return subscription.remove();
  });
  return lock;
};
