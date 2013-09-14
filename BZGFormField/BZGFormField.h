//
//  BZGFormField.h
//  BZGFormField
//
//  Created by Ben Guo on 9/14/13.
//  Copyright (c) 2013 BZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZGFormField : UIView <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIButton *leftIndicator;
@property (strong, nonatomic) UITextField *textField;

// sets the aspect ratio of the left indicator for the inactive state (editing, not tappable)
- (void)setLeftIndicatorInactiveAspectRatio:(CGFloat)aspectRatio;

// sets the aspect ratio of the left indicator for the active state (not editing, tappable)
- (void)setLeftIndicatorActiveAspectRatio:(CGFloat)aspectRatio;


@end
