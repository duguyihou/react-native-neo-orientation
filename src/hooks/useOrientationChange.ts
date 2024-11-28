import { useRef, useEffect, MutableRefObject } from 'react'
import Orientation, { OrientationCallback } from '../orientation'

export const useOrientationChange = (callback: OrientationCallback): void => {
  const savedCallback: MutableRefObject<OrientationCallback | undefined> = useRef()

  useEffect(() => {
    savedCallback.current = callback
  }, [callback])

  useEffect(() => {
    const listener = (ori: string): void => {
      if (savedCallback.current) {
        savedCallback.current(ori)
      }
    }
    const initial = Orientation.getInitialOrientation()
    listener(initial)
    Orientation.addDeviceOrientationListener(listener)

    return () => {
      Orientation.removeDeviceOrientationListener(listener)
    }
  }, [])
}
