//
//  BZGFormField.m
//  BZGFormField
//
//  Created by Ben Guo on 9/14/13.
//  Copyright (c) 2013 BZG. All rights reserved.
//

#import "BZGFormField.h"

// relative to self.frame.height
#define DEFAULT_LEFT_TEXT_PADDING 0.2
#define DEFAULT_LEFT_INDICATOR_INACTIVE_ASPECT_RATIO 0.2
#define DEFAULT_LEFT_INDICATOR_ACTIVE_ASPECT_RATIO 0.8

typedef NS_ENUM(NSInteger, BZGLeftIndicatorState) {
    BZGLeftIndicatorStateInactive,
    BZGLeftIndicatorStateActive
};

typedef NS_ENUM(NSInteger, BZGFormFieldState) {
    BZGFormFieldStateInvalid,
    BZGFormFieldStateValid,
    BZGFormFieldStateNone
};

@implementation BZGFormField {
    CGFloat _leftIndicatorInactiveAspectRatio;
    CGFloat _leftIndicatorActiveAspectRatio;
    CGFloat _leftTextPadding;

    // should I derive these states? yes.
    CGFloat _currentLeftIndicatorAspectRatio;
    BZGLeftIndicatorState _currentLeftIndicatorState;
}

#pragma mark - Public

- (void)setLeftIndicatorInactiveAspectRatio:(CGFloat)aspectRatio {
    _leftIndicatorInactiveAspectRatio = aspectRatio;
}

- (void)setLeftIndicatorActiveAspectRatio:(CGFloat)aspectRatio {
    _leftIndicatorActiveAspectRatio = aspectRatio;
}

- (void)setLeftTextPadding:(CGFloat)leftTextPadding {
    _leftTextPadding = leftTextPadding;
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
    _leftIndicatorInactiveAspectRatio = DEFAULT_LEFT_INDICATOR_INACTIVE_ASPECT_RATIO;
    _leftIndicatorActiveAspectRatio = DEFAULT_LEFT_INDICATOR_ACTIVE_ASPECT_RATIO;
    _currentLeftIndicatorAspectRatio = _leftIndicatorInactiveAspectRatio;
    _leftTextPadding = DEFAULT_LEFT_TEXT_PADDING;

    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor whiteColor]; // delete this
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.delegate = self;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.placeholder = @"TEST";
    [self addSubview:self.textField];

    self.leftIndicator = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftIndicator.backgroundColor = [UIColor grayColor];
    self.leftIndicator.titleLabel.textColor = [UIColor whiteColor];
    self.leftIndicator.titleLabel.font = [UIFont boldSystemFontOfSize:
                                          self.textField.font.pointSize*1.5];
    [self.leftIndicator setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:self.leftIndicator];
}

#pragma mark - Drawing

- (void)updateWithLeftIndicatorState:(BZGLeftIndicatorState)newLeftIndicatorState
                      formFieldState:(BZGFormFieldState)formFieldState
                            animated:(BOOL)animated
{
    BOOL shouldAnimate = (_currentLeftIndicatorState && !newLeftIndicatorState) || animated;
    _currentLeftIndicatorState = newLeftIndicatorState;
    switch (newLeftIndicatorState) {
        case BZGLeftIndicatorStateInactive:
            self.leftIndicator.userInteractionEnabled = NO;
            [self updateLeftIndicatorAspectRatio:_leftIndicatorInactiveAspectRatio animated:shouldAnimate];
            break;
        case BZGLeftIndicatorStateActive:
        default:
            self.leftIndicator.userInteractionEnabled = YES;
            [self updateLeftIndicatorAspectRatio:_leftIndicatorActiveAspectRatio animated:shouldAnimate];
            break;
    }
    switch (formFieldState) {
        case BZGFormFieldStateNone:
            self.leftIndicator.backgroundColor = [UIColor grayColor];
            [self.leftIndicator setTitle:@"" forState:UIControlStateNormal];
            break;
        case BZGFormFieldStateInvalid:
            self.leftIndicator.backgroundColor = [UIColor redColor];
            [self.leftIndicator setTitle:(newLeftIndicatorState) ? @"!" : @""
                                forState:UIControlStateNormal];
            break;
        case BZGFormFieldStateValid:
        default:
            self.leftIndicator.backgroundColor = [UIColor greenColor];
            [self.leftIndicator setTitle:@"" forState:UIControlStateNormal];
            break;
    }
}

- (void)updateLeftIndicatorAspectRatio:(CGFloat)aspectRatio animated:(BOOL)animated
{
    void (^animations)() = ^{
        self.leftIndicator.frame = CGRectMake(self.bounds.origin.x,
                                              self.bounds.origin.y,
                                              self.bounds.size.height*_currentLeftIndicatorAspectRatio,
                                              self.bounds.size.height);

        CGFloat textFieldX = self.bounds.size.height*(_currentLeftIndicatorAspectRatio+_leftTextPadding);
        self.textField.frame = CGRectMake(self.bounds.origin.x + textFieldX,
                                          self.bounds.origin.y,
                                          self.bounds.size.width - textFieldX,
                                          self.bounds.size.height);

    };
    _currentLeftIndicatorAspectRatio = aspectRatio;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:animations];
    } else {
        animations();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateLeftIndicatorAspectRatio:_currentLeftIndicatorAspectRatio animated:NO];
    self.leftIndicator.titleLabel.font = [UIFont boldSystemFontOfSize:
                                          self.textField.font.pointSize*1.5];


}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if (textField.text.length > 4) {
        [self updateWithLeftIndicatorState:BZGLeftIndicatorStateInactive formFieldState:BZGFormFieldStateValid animated:NO];
    } else {
        [self updateWithLeftIndicatorState:BZGLeftIndicatorStateInactive formFieldState:BZGFormFieldStateInvalid animated:NO];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length <= 5) {
        [self updateWithLeftIndicatorState:BZGLeftIndicatorStateActive formFieldState:BZGFormFieldStateInvalid animated:YES];
    }
}


#warning testing only
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
