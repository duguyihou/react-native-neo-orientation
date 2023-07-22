# react-native-neo-orientation

[![CI](https://github.com/duguyihou/react-native-neo-orientation/actions/workflows/ci.yml/badge.svg)](https://github.com/duguyihou/react-native-neo-orientation/actions/workflows/ci.yml)

device orientation for React Native

## Installation

```sh
npm install react-native-neo-orientation
```

or

```sh
yarn add react-native-neo-orientation
```

## Configuration

### iOS

Add the following to your project's AppDelegate.mm:

```diff

+#import <react-native-neo-orientation/NeoOrientation.h>

@implementation AppDelegate

// ...

+- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
+  return [NeoOrientation getOrientation];
+}

@end
```
## Usage

```typescript
import { Button, StyleSheet, Text, View } from 'react-native';
import React from 'react';
import NeoOrientation from 'react-native-neo-orientation';

const Home = () => {
  const handleLockTolandscape = () => {
    NeoOrientation.lockToLandscape();
  };

  const handleLockToPortrait = () => {
    NeoOrientation.lockToPortrait();
  };
  const handleLockToPortraitUpsideDown = () => {
    NeoOrientation.lockToPortraitUpsideDown();
  };
  const handleLockToLandscapeRight = () => {
    NeoOrientation.lockToLandscapeRight();
  };
  const handleLockToLandscapeLeft = () => {
    NeoOrientation.lockToLandscapeLeft();
  };
  const handleUnlockAllOrientations = () => {
    NeoOrientation.unlockAllOrientations();
  };
  return (
    <View style={styles.container}>
      <Text style={styles.text}>Home</Text>
      <Button title="Lock to landscape" onPress={handleLockTolandscape} />
      <Button title="Lock to portrait" onPress={handleLockToPortrait} />
      <Button
        title="Lock to portrait upside down"
        onPress={handleLockToPortraitUpsideDown}
      />
      <Button
        title="Lock to landscape right"
        onPress={handleLockToLandscapeRight}
      />
      <Button
        title="Lock to landscape left"
        onPress={handleLockToLandscapeLeft}
      />
      <Button
        title="Unlock all orientations"
        onPress={handleUnlockAllOrientations}
      />
    </View>
  );
};

export default Home;

const styles = StyleSheet.create({
  container: {
    backgroundColor: 'black',
    width: '100%',
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
  },
  text: {
    color: 'white',
    fontSize: 32,
  },
});
```

## Functions

  - `lockToLandscape`
  - `lockToPortrait`
  - `lockToPortraitUpsideDown`
  - `lockToLandscapeRight`
  - `lockToLandscapeLeft`
  - `lockToAllOrientationButUpsideDown`
  - `unlockAllOrientations`

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

