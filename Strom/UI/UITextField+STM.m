//
//  UITextField+STM.m
//  StromFacilitate
//
//  Created by WuYikai on 2017/6/30.
//  Copyright © 2017年 DouKing. All rights reserved.
//

#import "UITextField+STM.h"
#import "STMObjectRuntime.h"

@implementation UITextField (STM)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL systemSel = @selector(awakeFromNib);
    SEL swizzSel = @selector(stm_awakeFromNib);
    STMSwizzMethod(self, systemSel, swizzSel);

    systemSel = @selector(initWithFrame:);
    swizzSel = @selector(stm_initWithFrame:);
    STMSwizzMethod(self, systemSel, swizzSel);

    systemSel = NSSelectorFromString(@"dealloc");
    swizzSel = @selector(stm_dealloc);
    STMSwizzMethod(self, systemSel, swizzSel);
  });
}

- (void)stm_dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self stm_dealloc];
}

- (void)stm_awakeFromNib {
  [self stm_awakeFromNib];
  [self _initial];
}

- (instancetype)stm_initWithFrame:(CGRect)frame {
  UITextField *tf = [self stm_initWithFrame:frame];
  [tf _initial];
  return tf;
}

#pragma mark - Private Method

- (void)_initial {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_stm_handleTextChangeNotification:)
                                               name:UITextFieldTextDidChangeNotification
                                             object:nil];
}

- (void)_stm_handleTextChangeNotification:(NSNotification *)note {
  UITextField *tf = note.object;
  if (tf != self) { return; }
  [self _stm_tfTextDidChange:self];
}

- (void)_stm_tfTextDidChange:(UITextField *)textField {
  switch (self.stm_limitType) {
    case STMTextFieldInputLenthLimitTypeCharacter: {
      [self _stm_limitCharacterLength:self.stm_limitLength];
      break;
    }

    case STMTextFieldInputLenthLimitTypeByte: {
      [self _stm_limitByteLength:self.stm_limitLength];
      break;
    }
  }
}

- (void)_stm_limitCharacterLength:(NSUInteger)maxLength {
  if (0 == maxLength) {
    return;
  }
  UITextField *textField = self;
  NSString *text = textField.text;
  UITextRange *selectedRange = [textField markedTextRange];
  UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
  // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
  if (!position){
    // 字符处理
    if (text.length > maxLength){
      // 中文和emoj表情存在问题，需要对此进行处理
      NSRange range;
      NSUInteger inputLength = 0;
      for(int i = 0; i < text.length && inputLength <= maxLength; i += range.length) {
        range = [textField.text rangeOfComposedCharacterSequenceAtIndex:i];
        inputLength += [text substringWithRange:range].length;
        if (inputLength > maxLength) {
          NSString *resultText = [text substringWithRange:NSMakeRange(0, range.location)];
          textField.text = resultText;
        }
      }
    }
  }
}

- (void)_stm_limitByteLength:(NSUInteger)maxBytesLength {
  if (0 == maxBytesLength) {
    return;
  }
  UITextField *textField = self;
  NSString *text = textField.text;
  UITextRange *selectedRange = [textField markedTextRange];
  UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
  // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
  if (!position){
    // 字节处理
    // Limit
    NSUInteger textBytesLength = [textField.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (textBytesLength > maxBytesLength) {
      NSRange range;
      NSUInteger byteLength = 0;
      for(int i = 0; i < text.length && byteLength <= maxBytesLength; i += range.length) {
        range = [textField.text rangeOfComposedCharacterSequenceAtIndex:i];
        byteLength += strlen([[text substringWithRange:range] UTF8String]);
        if (byteLength > maxBytesLength) {
          NSString *resultText = [text substringWithRange:NSMakeRange(0, range.location)];
          textField.text = resultText;
        }
      }
    }
  }
}

#pragma mark - setter & getter

- (void)setStm_limitType:(STMTextFieldInputLenthLimitType)stm_limitType {
  objc_setAssociatedObject(self, @selector(stm_limitType), @(stm_limitType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (STMTextFieldInputLenthLimitType)stm_limitType {
  return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setStm_limitLength:(NSUInteger)stm_limitLength {
  objc_setAssociatedObject(self, @selector(stm_limitLength), @(stm_limitLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)stm_limitLength {
  return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)setStm_placeholderColor:(UIColor *)stm_placeholderColor {
  if (@available(iOS 13.0, *)) {
    NSLog(@"Please use attributedPlaceholder yourself!");
  } else {
    [self setValue:stm_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
  }
}

- (UIColor *)stm_placeholderColor {
  if (@available(iOS 13.0, *)) {
    NSLog(@"Please acquire placeholderColor use attributedPlaceholder yourself!");
    return nil;
  } else {
    return [self valueForKeyPath:@"_placeholderLabel.textColor"];
  }
}

@end
