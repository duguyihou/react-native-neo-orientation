export interface NeoOrientationAPI {
  lockToLandscape: () => void;
  lockToPortrait: () => void;
  lockToLandscapeRight: () => void;
  lockToLandscapeLeft: () => void;
  lockToAllOrientationButUpsideDown: () => void;
  unlockAllOrientations: () => void;
}

export type OrientationStatus =
  | 'portrait'
  | 'landscapeLeft'
  | 'landscapeRight'
  | 'portraitUpsideDown'
  | 'unknown';

export type DeviceOrientationStatus =
  | 'portrait'
  | 'landscapeLeft'
  | 'landscapeRight'
  | 'portraitUpsideDown'
  | 'faceUp'
  | 'faceDown'
  | 'unknown';

export type LockStatus = boolean | null;
