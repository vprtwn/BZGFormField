//
//  DemoViewController.m
//  BZGFormField
//
//  Created by Ben Guo on 9/14/13.
//  Copyright (c) 2013 BZG. All rights reserved.
//

#import "DemoViewController.h"
#import "BZGFormField.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.emailField.textField.placeholder = @"Email";
    __weak DemoViewController *weakSelf = self;
    [self.emailField setTextValidationBlock:^BOOL(NSString *text) {
        // source https://github.com/benmcredmond/DHValidation/blob/master/DHValidation.m
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:text]) {
            weakSelf.emailField.alertView.title = @"Invalid email address";
            return NO;
        } else {
            return YES;
        }
    }];
    self.passwordField.textField.placeholder = @"Password";
    self.passwordField.textField.secureTextEntry = YES;
    [self.passwordField setTextValidationBlock:^BOOL(NSString *text) {
        if (text.length < 8) {
            weakSelf.passwordField.alertView.title = @"Password is too short";
            return NO;
        } else {
            return YES;
        }
    }];
    self.passwordConfirmField.textField.placeholder = @"Confirm Password";
    self.passwordConfirmField.textField.secureTextEntry = YES;
    [self.passwordConfirmField setTextValidationBlock:^BOOL(NSString *text) {
        if (![text isEqualToString:self.passwordField.textField.text]) {
            weakSelf.passwordConfirmField.alertView.title = @"Password confirm doesn't match";
            return NO;
        } else {
            return YES;
        }
    }];
}

@end
