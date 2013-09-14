//
//  BZGFormField.m
//  BZGFormField
//
//  Created by Ben Guo on 9/14/13.
//  Copyright (c) 2013 BZG. All rights reserved.
//

#import "BZGFormField.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

// relative to self.frame.height
#define DEFAULT_LEFT_TEXT_PADDING 0.2
#define DEFAULT_LEFT_INDICATOR_INACTIVE_ASPECT_RATIO 0.2
#define DEFAULT_LEFT_INDICATOR_ACTIVE_ASPECT_RATIO 0.8
#define DEFAULT_NONE_COLOR UIColorFromRGB(0x95A5A6)
#define DEFAULT_VALID_COLOR UIColorFromRGB(0x2ECC71)
#define DEFAULT_INVALID_COLOR UIColorFromRGB(0xE74C3C)

typedef NS_ENUM(NSInteger, BZGLeftIndicatorState) {
    BZGLeftIndicatorStateInactive,
    BZGLeftIndicatorStateActive
};

typedef NS_ENUM(NSInteger, BZGFormFieldState) {
    BZGFormFieldStateInvalid,
    BZGFormFieldStateValid,
    BZGFormFieldStateNone
};

@interface BZGFormField ()

@property (strong, nonatomic) UIColor *invalidColor;
@property (strong, nonatomic) UIColor *validColor;
@property (strong, nonatomic) UIColor *noneColor;

@end


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

    self.invalidColor = DEFAULT_NONE_COLOR;
    self.validColor = DEFAULT_VALID_COLOR;
    self.invalidColor = DEFAULT_INVALID_COLOR;

    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.delegate = self;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.placeholder = @"Placeholder";
    self.textField.text = @" ";
    [self addSubview:self.textField];

    self.leftIndicator = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftIndicator.titleLabel.textColor = [UIColor whiteColor];
    [self.leftIndicator addTarget:self action:@selector(leftIndicatorTouch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftIndicator];
    [self updateWithLeftIndicatorState:BZGLeftIndicatorStateInactive
                        formFieldState:BZGFormFieldStateNone animated:NO];
    self.textField.text = @"";

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
            self.leftIndicator.backgroundColor = self.noneColor;
            [self.leftIndicator setTitle:@"" forState:UIControlStateNormal];
            break;
        case BZGFormFieldStateInvalid:
            self.leftIndicator.backgroundColor = self.invalidColor;
            [self.leftIndicator setTitle:(newLeftIndicatorState) ? @"!" : @""
                                forState:UIControlStateNormal];
            break;
        case BZGFormFieldStateValid:
        default:
            self.leftIndicator.backgroundColor = self.validColor;
            [self.leftIndicator setTitle:@"" forState:UIControlStateNormal];
            break;
    }
}

- (void)updateLeftIndicatorAspectRatio:(CGFloat)aspectRatio animated:(BOOL)animated
{
    _currentLeftIndicatorAspectRatio = aspectRatio;
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
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:animations completion:nil];
    } else {
        animations();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateLeftIndicatorAspectRatio:_currentLeftIndicatorAspectRatio animated:NO];
    self.leftIndicator.titleLabel.font = [UIFont systemFontOfSize:
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

#pragma mark - Actions

- (void)leftIndicatorTouch
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"alert view"
                                                        message:@"woop"
                                                       delegate:self
                                              cancelButtonTitle:@"swag"
                                              otherButtonTitles:nil];
    [alertView show];
}


#warning testing only
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
