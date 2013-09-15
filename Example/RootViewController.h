//
// RootViewController.h
//
// Copyright (c) 2013 Ben Guo
//
// https://github.com/benzguo/BZGFormField
//

#import <UIKit/UIKit.h>
#import "BZGFormField.h"

@protocol BZGFormFieldDelegate;

@interface RootViewController : UIViewController <BZGFormFieldDelegate>

@property (weak, nonatomic) IBOutlet BZGFormField *emailField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordConfirmField;

@end
