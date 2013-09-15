//
// BZGFormField.h
//
// Copyright (c) 2013 Ben Guo
//
// https://github.com/benzguo/BZGFormField
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BZGLeftIndicatorState) {
    BZGLeftIndicatorStateInactive,
    BZGLeftIndicatorStateActive
};

typedef NS_ENUM(NSInteger, BZGFormFieldState) {
    BZGFormFieldStateInvalid,
    BZGFormFieldStateValid,
    BZGFormFieldStateNone
};

@protocol BZGFormFieldDelegate;

typedef BOOL (^BZGTextValidationBlock)(NSString *text);

@interface BZGFormField : UIView <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) id <BZGFormFieldDelegate> delegate;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *leftIndicator;
@property (strong, nonatomic) UIAlertView *alertView;

/**
 The width of the left indicator when inactive, relative to the height of the form field.
 */
@property (assign, nonatomic) CGFloat leftIndicatorInactiveWidth;

/**
 The width of the left indicator when active, relative to the height of the form field.
 */
@property (assign, nonatomic) CGFloat leftIndicatorActiveWidth;

/**
 The padding between the left indicator and the text field, relative to the height of the form field.
 */
@property (assign, nonatomic) CGFloat leftIndicatorRightPadding;

/**
 The color of the left indicator when the form is invalid.
 */
@property (strong, nonatomic) UIColor *leftIndicatorInvalidColor;

/**
 The color of the left indicator when the form is valid.
 */
@property (strong, nonatomic) UIColor *leftIndicatorValidColor;

/**
 The color of the left indicator when the form is neither invalid nor valid.
 */
@property (strong, nonatomic) UIColor *leftIndicatorNoneColor;

/**
 Returns the current state of the form (invalid | valid | none)
 */
- (BZGFormFieldState)formFieldState;

/**
 Returns the current state of the left indicator (inactive | active)
 */
- (BZGLeftIndicatorState)leftIndicatorState;

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
