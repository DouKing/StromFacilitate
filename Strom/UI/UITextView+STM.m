//
//  UITextView+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2019/1/24.
//  Copyright © 2019 DouKing. All rights reserved.
//

#import "UITextView+STM.h"
#import "STMObjectRuntime.h"

@implementation UITextView (STM)

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
  UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
  if (label) {
    for (NSString *key in self.class.observingKeys) {
      @try {
        [self removeObserver:self forKeyPath:key];
      }
      @catch (NSException *exception) {
        // Do nothing
      }
    }
  }
  [self stm_dealloc];
}

- (void)stm_awakeFromNib {
  [self stm_awakeFromNib];
  [self _initial];
}

- (instancetype)stm_initWithFrame:(CGRect)frame {
  UITextView *tf = [self stm_initWithFrame:frame];
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
  UITextView *tf = note.object;
  if (tf != self) { return; }
  [self _stm_tfTextDidChange:self];
}

- (void)_stm_tfTextDidChange:(UITextView *)textView {
  switch (self.limitType) {
    case STMTextViewInputLenthLimitTypeCharacter: {
      [self _stm_limitCharacterLength:self.limitLength];
      break;
    }

    case STMTextViewInputLenthLimitTypeByte: {
      [self _stm_limitByteLength:self.limitLength];
      break;
    }
  }
}

- (void)_stm_limitCharacterLength:(NSUInteger)maxLength {
  if (0 == maxLength) {
    return;
  }
  UITextView *textView = self;
  NSString *text = textView.text;
  UITextRange *selectedRange = [textView markedTextRange];
  UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
  // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
  if (!position){
    // 字符处理
    if (text.length > maxLength){
      // 中文和emoj表情存在问题，需要对此进行处理
      NSRange range;
      NSUInteger inputLength = 0;
      for(int i = 0; i < text.length && inputLength <= maxLength; i += range.length) {
        range = [textView.text rangeOfComposedCharacterSequenceAtIndex:i];
        inputLength += [text substringWithRange:range].length;
        if (inputLength > maxLength) {
          NSString *resultText = [text substringWithRange:NSMakeRange(0, range.location)];
          textView.text = resultText;
        }
      }
    }
  }
}

- (void)_stm_limitByteLength:(NSUInteger)maxBytesLength {
  if (0 == maxBytesLength) {
    return;
  }
  UITextView *textView = self;
  NSString *text = textView.text;
  UITextRange *selectedRange = [textView markedTextRange];
  UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
  // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
  if (!position){
    // 字节处理
    // Limit
    NSUInteger textBytesLength = [textView.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (textBytesLength > maxBytesLength) {
      NSRange range;
      NSUInteger byteLength = 0;
      for(int i = 0; i < text.length && byteLength <= maxBytesLength; i += range.length) {
        range = [textView.text rangeOfComposedCharacterSequenceAtIndex:i];
        byteLength += strlen([[text substringWithRange:range] UTF8String]);
        if (byteLength > maxBytesLength) {
          NSString *resultText = [text substringWithRange:NSMakeRange(0, range.location)];
          textView.text = resultText;
        }
      }
    }
  }
}

+ (UIColor *)defaultPlaceholderColor {
  static UIColor *color = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @" ";
    color = [textField valueForKeyPath:@"_placeholderLabel.textColor"];
  });
  return color;
}

+ (NSArray *)observingKeys {
  return @[@"attributedText",
           @"bounds",
           @"font",
           @"frame",
           @"text",
           @"textAlignment",
           @"textContainerInset"];
}

#pragma mark - Update

- (void)_updatePlaceholderLabel {
  if (self.text.length) {
    [self.placeholderLabel removeFromSuperview];
    return;
  }

  [self insertSubview:self.placeholderLabel atIndex:0];

  if (self.needsUpdateFont) {
    self.placeholderLabel.font = self.font;
    self.needsUpdateFont = NO;
  }
  self.placeholderLabel.textAlignment = self.textAlignment;

  // `NSTextContainer` is available since iOS 7
  CGFloat lineFragmentPadding;
  UIEdgeInsets textContainerInset;

  lineFragmentPadding = self.textContainer.lineFragmentPadding;
  textContainerInset = self.textContainerInset;

  CGFloat x = lineFragmentPadding + textContainerInset.left;
  CGFloat y = textContainerInset.top;
  CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
  CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
  self.placeholderLabel.frame = CGRectMake(x, y, width, height);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:@"font"]) {
    self.needsUpdateFont = (change[NSKeyValueChangeNewKey] != nil);
  }
  [self _updatePlaceholderLabel];
}

#pragma mark - setter & getter

- (void)setLimitType:(STMTextViewInputLenthLimitType)limitType {
  objc_setAssociatedObject(self, @selector(limitType), @(limitType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (STMTextViewInputLenthLimitType)limitType {
  return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setLimitLength:(NSUInteger)limitLength {
  objc_setAssociatedObject(self, @selector(limitLength), @(limitLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)limitLength {
  return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (UILabel *)placeholderLabel {
  UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
  if (!label) {
    NSAttributedString *originalText = self.attributedText;
    self.text = @" "; // lazily set font of `UITextView`.
    self.attributedText = originalText;

    label = [[UILabel alloc] init];
    label.textColor = [self.class defaultPlaceholderColor];
    label.numberOfLines = 0;
    label.userInteractionEnabled = NO;
    objc_setAssociatedObject(self, @selector(placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self.needsUpdateFont = YES;
    [self _updatePlaceholderLabel];
    self.needsUpdateFont = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updatePlaceholderLabel)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];

    for (NSString *key in self.class.observingKeys) {
      [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
    }
  }
  return label;
}

- (NSString *)placeholder {
  return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
  self.placeholderLabel.text = placeholder;
  [self _updatePlaceholderLabel];
}

- (NSAttributedString *)attributedPlaceholder {
  return self.placeholderLabel.attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
  self.placeholderLabel.attributedText = attributedPlaceholder;
  [self _updatePlaceholderLabel];
}

- (UIColor *)placeholderColor {
  return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
  self.placeholderLabel.textColor = placeholderColor;
}

- (BOOL)needsUpdateFont {
  return [objc_getAssociatedObject(self, @selector(needsUpdateFont)) boolValue];
}

- (void)setNeedsUpdateFont:(BOOL)needsUpdate {
  objc_setAssociatedObject(self, @selector(needsUpdateFont), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
