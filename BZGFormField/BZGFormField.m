//
// BZGFormField.m
//
// Copyright (c) 2013 Ben Guo
//
// https://github.com/benzguo/BZGFormField
//

#import "BZGFormField.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

// relative to self.frame.height
#define DEFAULT_LEFT_INDICATOR_RIGHT_PADDING 0.2
#define DEFAULT_LEFT_INDICATOR_RELATIVE_WIDTH 0.2
#define DEFAULT_NONE_COLOR UIColorFromRGB(0x95A5A6)
#define DEFAULT_VALID_COLOR UIColorFromRGB(0x2ECC71)
#define DEFAULT_INVALID_COLOR UIColorFromRGB(0xE74C3C)

@implementation BZGFormField {
    BZGFormFieldState _currentFormFieldState;
    BZGTextValidationBlock _textValidationBlock;
}

#pragma mark - Public

- (BZGFormFieldState)formFieldState
{
    return _currentFormFieldState;
}


- (void)setTextValidationBlock:(BZGTextValidationBlock)block
{
    _textValidationBlock = block;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup
{
    self.leftIndicatorRelativeWidth = DEFAULT_LEFT_INDICATOR_RELATIVE_WIDTH;
    self.leftIndicatorRelativeRightPadding = DEFAULT_LEFT_INDICATOR_RIGHT_PADDING;
    _textValidationBlock = ^BOOL(NSString *text) { return YES; };

    self.leftIndicatorInvalidColor = DEFAULT_INVALID_COLOR;
    self.leftIndicatorValidColor = DEFAULT_VALID_COLOR;
    self.leftIndicatorNoneColor = DEFAULT_NONE_COLOR;

    self.textField = [[UITextField alloc] init];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.delegate = self;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.text = @" ";
    [self addSubview:self.textField];

    self.leftIndicator = [[UIView alloc] init];
    [self addSubview:self.leftIndicator];
    [self updateLeftIndicator:BZGFormFieldStateNone];
    self.textField.text = @"";

    self.alertView = [[UIAlertView alloc] initWithTitle:@""
                                                message:@""
                                               delegate:self
                                      cancelButtonTitle:@"Ok"
                                      otherButtonTitles:nil];
    self.alertView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification object:nil];

}

#pragma mark - Drawing

- (void)updateLeftIndicator:(BZGFormFieldState)formFieldState
{
    _currentFormFieldState = formFieldState;
    switch (formFieldState) {
        case BZGFormFieldStateNone:
            self.leftIndicator.backgroundColor = self.leftIndicatorNoneColor;
            break;
        case BZGFormFieldStateInvalid:
            self.leftIndicator.backgroundColor = self.leftIndicatorInvalidColor;
            break;
        case BZGFormFieldStateValid:
        default:
            self.leftIndicator.backgroundColor = self.leftIndicatorValidColor;
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat fieldHeight = self.bounds.size.height;
    self.leftIndicator.frame = CGRectMake(self.bounds.origin.x,
                                          self.bounds.origin.y,
                                          self.leftIndicatorRelativeWidth*fieldHeight,
                                          self.bounds.size.height);
    CGRect textFieldFrame = self.leftIndicator.frame;
    textFieldFrame.origin.x += self.leftIndicator.frame.size.width + self.leftIndicatorRelativeRightPadding*fieldHeight;
    textFieldFrame.size.width = self.bounds.size.width - textFieldFrame.origin.x;
    self.textField.frame = textFieldFrame;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.delegate textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.delegate textFieldShouldEndEditing:textField];
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self updateLeftIndicator:BZGFormFieldStateNone];
    } else if (_textValidationBlock(textField.text)) {
        [self updateLeftIndicator:BZGFormFieldStateValid];
    } else {
        [self updateLeftIndicator:BZGFormFieldStateInvalid];
    }

    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (_textValidationBlock(newText)) {
        [self updateLeftIndicator:BZGFormFieldStateValid];
    } else {
        [self updateLeftIndicator:BZGFormFieldStateInvalid];
    }

    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate textField:textField
          shouldChangeCharactersInRange:range
                      replacementString:string];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self updateLeftIndicator:BZGFormFieldStateNone];

    if ([self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.delegate textFieldShouldClear:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate textFieldShouldReturn:textField];
    } else {
        return YES;
    }
}

#pragma mark - UITextField notifications

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    if ([textField isEqual:self.textField] && !textField.text.length) {
        [self updateLeftIndicator:BZGFormFieldStateNone];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.textField becomeFirstResponder];

    if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}

#pragma mark - Actions

- (void)leftIndicatorTouchDown
{
    UIColor *color = [self.leftIndicator.backgroundColor colorWithAlphaComponent:0.8];
    self.leftIndicator.backgroundColor = color;
}

- (void)leftIndicatorTouchUp
{
    UIColor *color = [self.leftIndicator.backgroundColor colorWithAlphaComponent:1.0];
    self.leftIndicator.backgroundColor = color;

    [self.alertView show];
}




@end
