import { Button, StyleSheet, TextInput, View } from 'react-native';
import CalculatorKeyboard from 'react-native-calculator-keyboard';
import React, { useState } from 'react';

export default function App() {
  const ref1 = React.useRef<TextInput>(null);
  const ref2 = React.useRef<TextInput>(null);

  const [value1, setValue1] = useState('');
  const [value2, setValue2] = useState('');

  return (
    <View style={styles.container}>
      <View style={styles.styleRow}>
        <TextInput
          ref={ref1}
          placeholder={'Type value for Calculator...'}
          onChangeText={setValue1}
          style={styles.input}
          keyboardType={'numeric'}
        />
        <Button
          title={'Set Value'}
          onPress={() => {
            setValue2(value1);
          }}
        />
      </View>
      <View style={styles.styleRow}>
        <CalculatorKeyboard
          ref={ref2}
          value={value2}
          onChangeText={setValue2}
          onFocus={() => {
            console.log('focus');
          }}
          onBlur={() => {
            console.log('blur');
          }}
          onPress={(text) => {
            console.log(text);
          }}
          keyboardColor="#eb2f96"
          style={styles.input}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 12,
  },
  styleRow: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  input: {
    height: 56,
    margin: 12,
    borderWidth: 0.5,
    borderColor: 'red',
    borderRadius: 12,
    flex: 1,
  },
});
