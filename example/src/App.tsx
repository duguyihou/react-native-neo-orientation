import React from 'react';
import { SafeAreaView, StatusBar, StyleSheet } from 'react-native';
import Home from './Home';

function App(): JSX.Element {
  return (
    <SafeAreaView style={styles.container}>
      <StatusBar />
      <Home />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    height: '100%',
  },
});

export default App;
