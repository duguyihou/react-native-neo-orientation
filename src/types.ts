export interface NeoOrientationAPI {
  lockToLandscape: () => void;
  lockToPortrait: () => void;
  lockToPortraitUpsideDown: () => void;
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
