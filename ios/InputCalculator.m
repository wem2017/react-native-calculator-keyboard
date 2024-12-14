#import <InputCalculator-Bridging-Header.h>

@implementation Calculator

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

@end

@interface RCT_EXTERN_MODULE(RCTInputCalculator, RCTViewManager)

RCT_REMAP_VIEW_PROPERTY(autoCapitalize, backedTextInputView.autocapitalizationType, UITextAutocapitalizationType)
RCT_REMAP_VIEW_PROPERTY(autoCorrect, backedTextInputView.autocorrectionType, UITextAutocorrectionType)
RCT_REMAP_VIEW_PROPERTY(contextMenuHidden, backedTextInputView.contextMenuHidden, BOOL)
RCT_REMAP_VIEW_PROPERTY(editable, backedTextInputView.editable, BOOL)
RCT_REMAP_VIEW_PROPERTY(enablesReturnKeyAutomatically, backedTextInputView.enablesReturnKeyAutomatically, BOOL)
RCT_REMAP_VIEW_PROPERTY(keyboardAppearance, backedTextInputView.keyboardAppearance, UIKeyboardAppearance)
RCT_REMAP_VIEW_PROPERTY(placeholder, backedTextInputView.placeholder, NSString)
RCT_REMAP_VIEW_PROPERTY(placeholderTextColor, backedTextInputView.placeholderColor, UIColor)
RCT_REMAP_VIEW_PROPERTY(returnKeyType, backedTextInputView.returnKeyType, UIReturnKeyType)
RCT_REMAP_VIEW_PROPERTY(selectionColor, backedTextInputView.tintColor, UIColor)
RCT_REMAP_VIEW_PROPERTY(spellCheck, backedTextInputView.spellCheckingType, UITextSpellCheckingType)
RCT_REMAP_VIEW_PROPERTY(caretHidden, backedTextInputView.caretHidden, BOOL)
RCT_REMAP_VIEW_PROPERTY(clearButtonMode, backedTextInputView.clearButtonMode, UITextFieldViewMode)
RCT_REMAP_VIEW_PROPERTY(scrollEnabled, backedTextInputView.scrollEnabled, BOOL)
RCT_REMAP_VIEW_PROPERTY(secureTextEntry, backedTextInputView.secureTextEntry, BOOL)
RCT_REMAP_VIEW_PROPERTY(smartInsertDelete, backedTextInputView.smartInsertDeleteType, UITextSmartInsertDeleteType)

RCT_EXPORT_VIEW_PROPERTY(autoFocus, BOOL)
RCT_EXPORT_VIEW_PROPERTY(submitBehavior, NSString)
RCT_EXPORT_VIEW_PROPERTY(clearTextOnFocus, BOOL)
RCT_EXPORT_VIEW_PROPERTY(keyboardType, UIKeyboardType)
RCT_EXPORT_VIEW_PROPERTY(showSoftInputOnFocus, BOOL)
RCT_EXPORT_VIEW_PROPERTY(maxLength, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(selectTextOnFocus, BOOL)
RCT_EXPORT_VIEW_PROPERTY(selection, RCTTextSelection)
RCT_EXPORT_VIEW_PROPERTY(inputAccessoryViewID, NSString)
RCT_EXPORT_VIEW_PROPERTY(textContentType, NSString)
RCT_EXPORT_VIEW_PROPERTY(passwordRules, NSString)

RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onKeyPressSync, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onChangeSync, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSelectionChange, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onScroll, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(mostRecentEventCount, NSInteger)

RCT_EXPORT_SHADOW_PROPERTY(text, NSString)
RCT_EXPORT_SHADOW_PROPERTY(placeholder, NSString)
RCT_EXPORT_SHADOW_PROPERTY(onContentSizeChange, RCTDirectEventBlock)

RCT_EXPORT_METHOD(focus : (nonnull NSNumber *)viewTag)
{
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
    UIView *view = viewRegistry[viewTag];
    [view reactFocus];
  }];
}

RCT_EXPORT_METHOD(blur : (nonnull NSNumber *)viewTag)
{
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
    UIView *view = viewRegistry[viewTag];
    [view reactBlur];
  }];
}

RCT_EXPORT_VIEW_PROPERTY(keyboardColor, UIColor)

@end

