//
//  BZGFormField.h
//  BZGFormField
//
//  Created by Ben Guo on 9/14/13.
//  Copyright (c) 2013 BZG. All rights reserved.
//
// iOS 5+

#import <UIKit/UIKit.h>

@protocol BZGFormFieldDelegate;

typedef BOOL (^BZGTextValidationBlock)(NSString *text);

@interface BZGFormField : UIView <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIButton *leftIndicator;
@property (strong, nonatomic) UITextField *textField;
@property (weak, nonatomic) id <BZGFormFieldDelegate> delegate;

// sets the aspect ratio of the left indicator for the inactive state (editing, not tappable)
- (void)setLeftIndicatorInactiveAspectRatio:(CGFloat)aspectRatio;

// sets the aspect ratio of the left indicator for the active state (not editing, tappable)
- (void)setLeftIndicatorActiveAspectRatio:(CGFloat)aspectRatio;

// sets the validation block for the text field
- (void)setTextValidationBlock:(BZGTextValidationBlock)block;

@end

@protocol BZGFormFieldDelegate <UITextFieldDelegate>


@end
