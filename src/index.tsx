import React from 'react';
import {
  type NativeSyntheticEvent,
  type TextInputChangeEventData,
  type TextInputProps,
  type ColorValue,
  processColor,
} from 'react-native';
import { requireNativeComponent, TextInput } from 'react-native';

const NativeInput = requireNativeComponent<any>('RCTInputCalculator');

interface InputCalculatorProps extends TextInputProps {
  text?: string | undefined;
  keyboardColor?: ColorValue;
}

const InputCalculator = React.forwardRef<TextInput, InputCalculatorProps>(
  (props, ref) => {
    const _onChange = (
      event: NativeSyntheticEvent<TextInputChangeEventData>
    ) => {
      const currentText = event.nativeEvent.text;
      props.onChange && props.onChange(event);
      props.onChangeText && props.onChangeText(currentText);
    };

    const text = props.text || props.defaultValue || '';

    return (
      <NativeInput
        {...props}
        ref={ref}
        onChange={_onChange}
        text={text}
        keybardColor={processColor(props.keyboardColor)}
      />
    );
  }
);

export default InputCalculator;

export type { InputCalculatorProps };
