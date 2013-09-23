//
// BZGFormField.h
//
// Copyright (c) 2013 Ben Guo
//
// https://github.com/benzguo/BZGFormField
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BZGFormFieldState) {
    BZGFormFieldStateInvalid,
    BZGFormFieldStateValid,
    BZGFormFieldStateNone
};

@protocol BZGFormFieldDelegate;
@class BZGTooltip;

typedef BOOL (^BZGTextValidationBlock)(NSString *text);

@interface BZGFormField : UIView <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) id <BZGFormFieldDelegate> delegate;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *validityIndicator;
@property (strong, nonatomic) UIView *infoBackdrop;
@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) BZGTooltip *infoTooltip;

/**
 The width of the left indicator, relative to the height of the form field.
 */
@property (assign, nonatomic) CGFloat validityIndicatorRelativeWidth;

/**
 The padding between the left indicator and the text field, relative to the height of the form field.
 */
@property (assign, nonatomic) CGFloat textFieldRelativePadding;

/**
 The color of the left indicator when the form is invalid.
 */
@property (strong, nonatomic) UIColor *validityIndicatorInvalidColor;

/**
 The color of the left indicator when the form is valid.
 */
@property (strong, nonatomic) UIColor *validityIndicatorValidColor;

/**
 The color of the left indicator when the form is neither invalid nor valid.
 */
@property (strong, nonatomic) UIColor *validityIndicatorNoneColor;

/**
 Returns the current state of the form (invalid | valid | none)
 */
- (BZGFormFieldState)formFieldState;

/**
 Sets the validation block for the text field.
  */
- (void)setTextValidationBlock:(BZGTextValidationBlock)block;

@end

/**
 At the moment, a form field just forwards all UITextFieldDelegate and UIAlertViewDelegate messages to its delegate.
*/
@protocol BZGFormFieldDelegate <UITextFieldDelegate, UIAlertViewDelegate>

@end
