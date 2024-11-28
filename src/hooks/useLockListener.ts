import { useRef, useEffect, type MutableRefObject } from 'react';
import Orientation, { type OrientationCallback } from '../orientation';

export const useLockListener = (callback: OrientationCallback): void => {
  const savedCallback: MutableRefObject<OrientationCallback | undefined> =
    useRef();

  useEffect(() => {
    savedCallback.current = callback;
  }, [callback]);

  useEffect(() => {
    const listener = (ori: string): void => {
      if (savedCallback.current) {
        savedCallback.current(ori);
      }
    };
    Orientation.addLockListener(listener);

    return () => {
      Orientation.removeLockListener(listener);
    };
  }, []);
};
