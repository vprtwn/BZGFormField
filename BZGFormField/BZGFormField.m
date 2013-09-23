//
// BZGFormField.m
//
// Copyright (c) 2013 Ben Guo
//
// https://github.com/benzguo/BZGFormField
//

#import "BZGFormField.h"
#import "BZGTooltip.h"

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
    self.clipsToBounds = NO;
    self.validityIndicatorRelativeWidth = DEFAULT_LEFT_INDICATOR_RELATIVE_WIDTH;
    self.textFieldRelativePadding = DEFAULT_LEFT_INDICATOR_RIGHT_PADDING;
    _textValidationBlock = ^BOOL(NSString *text) { return YES; };

    self.validityIndicatorInvalidColor = DEFAULT_INVALID_COLOR;
    self.validityIndicatorValidColor = DEFAULT_VALID_COLOR;
    self.validityIndicatorNoneColor = DEFAULT_NONE_COLOR;

    self.textField = [[UITextField alloc] init];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.delegate = self;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.clearButtonMode = UITextFieldViewModeNever;
    self.textField.text = @" ";
    [self addSubview:self.textField];

    self.infoBackdrop = [[UIView alloc] init];
    self.infoBackdrop.backgroundColor = [UIColor clearColor];
    self.infoBackdrop.clipsToBounds = YES;
    self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.infoButton.tintColor = DEFAULT_NONE_COLOR;
    self.infoButton.userInteractionEnabled = YES;
    self.infoButton.hidden = YES;
    [self.infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.infoBackdrop.hidden = NO;
    [self.infoBackdrop addSubview:self.infoButton];
    [self addSubview:self.infoBackdrop];

    self.infoTooltip = [BZGTooltip sharedTooltip];

    self.validityIndicator = [[UIView alloc] init];
    [self addSubview:self.validityIndicator];
    [self updateValidityIndicator:BZGFormFieldStateNone];

    self.textField.text = @"";

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification object:nil];

}

#pragma mark - Actions

- (void)infoButtonAction
{
    [self showOrHideInfoTooltip];
}

#pragma mark - Drawing

- (void)showOrHideInfoTooltip
{
    if (self.infoTooltip.hidden) {
        [self.infoTooltip setTargetRect:self.infoButton.frame inView:self];
        [self.infoTooltip setTooltipVisible:YES animated:YES];
    } else {
        [self.infoTooltip setTooltipVisible:NO animated:YES];
    }
}

- (void)showInfoButton
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.infoButton.hidden = NO;
        CGRect infoButtonFrame = self.infoBackdrop.frame;
        infoButtonFrame.origin.x = 0;
        self.infoButton.frame = infoButtonFrame;
    } completion:nil];
}

- (void)hideInfoButton
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect infoButtonFrame = self.infoBackdrop.frame;
        infoButtonFrame.origin.x = infoButtonFrame.size.width;
        self.infoButton.frame = infoButtonFrame;
    } completion:^(BOOL finished) {
        self.infoButton.hidden = YES;
    }];
}

- (void)updateValidityIndicator:(BZGFormFieldState)formFieldState
{
    _currentFormFieldState = formFieldState;
    switch (formFieldState) {
        case BZGFormFieldStateNone:
            self.validityIndicator.backgroundColor = self.validityIndicatorNoneColor;
            break;
        case BZGFormFieldStateInvalid:
            self.validityIndicator.backgroundColor = self.validityIndicatorInvalidColor;
            break;
        case BZGFormFieldStateValid:
        default:
            self.validityIndicator.backgroundColor = self.validityIndicatorValidColor;
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat fieldHeight = self.bounds.size.height;
    self.validityIndicator.frame = CGRectMake(self.bounds.origin.x,
                                          self.bounds.origin.y,
                                          self.validityIndicatorRelativeWidth*fieldHeight,
                                          self.bounds.size.height);

    CGRect textFieldFrame = self.validityIndicator.frame;
    textFieldFrame.origin.x += self.validityIndicator.frame.size.width + self.textFieldRelativePadding*fieldHeight;
    textFieldFrame.size.width = self.bounds.size.width - textFieldFrame.origin.x;
    self.textField.frame = textFieldFrame;

    CGRect infoBackdropFrame = textFieldFrame;
    infoBackdropFrame.origin.x = self.bounds.size.width - self.bounds.size.height;
    infoBackdropFrame.size.width = self.bounds.size.height;
    self.infoBackdrop.frame = infoBackdropFrame;

    CGRect infoButtonFrame = infoBackdropFrame;
    infoButtonFrame.origin.x = infoBackdropFrame.size.width;
    self.infoButton.frame = infoButtonFrame;
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
    if (textField != self.textField) return;

    [self hideInfoButton];

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
    if (textField != self.textField) return;

    if (textField.text.length == 0) {
        [self updateValidityIndicator:BZGFormFieldStateNone];
    } else if (_textValidationBlock(textField.text)) {
        [self updateValidityIndicator:BZGFormFieldStateValid];
    } else {
        [self updateValidityIndicator:BZGFormFieldStateInvalid];
    }

    if (_currentFormFieldState == BZGFormFieldStateInvalid) {
        [self showInfoButton];
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
        [self updateValidityIndicator:BZGFormFieldStateValid];
    } else {
        [self updateValidityIndicator:BZGFormFieldStateInvalid];
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
    [self updateValidityIndicator:BZGFormFieldStateNone];

    if ([self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.delegate textFieldShouldClear:textField];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_currentFormFieldState == BZGFormFieldStateInvalid) {
        [self showInfoButton];
    }

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
        [self updateValidityIndicator:BZGFormFieldStateNone];
    }
}




@end
