//
// BZGFormField.h
//
// Copyright (c) 2013 Ben Guo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
