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
