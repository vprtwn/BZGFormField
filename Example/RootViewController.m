//
// RootViewController.m
//
// https://github.com/benzguo/BZGFormField
//

#import "RootViewController.h"
#import "BZGFormField.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.emailField.textField.placeholder = @"Email";
    __weak RootViewController *weakSelf = self;
    [self.emailField setTextValidationBlock:^BOOL(NSString *text) {
        // from https://github.com/benmcredmond/DHValidation/blob/master/DHValidation.m
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:text]) {
            weakSelf.emailField.alertView.title = @"Invalid email address";
            return NO;
        } else {
            return YES;
        }
    }];
    
    //Add online validation
    [self.emailField setAsyncTextValidationBlock:^BOOL(NSString *text) {
        NSError *error;
        NSString *str = [NSString stringWithFormat:@"https://api.mailgun.net/v2/address/validate?address=%@&api_key=%@", [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"pubkey-5ogiflzbnjrljiky49qxsiozqef5jxp7"];
        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        
        if (!responseData) {
            weakSelf.emailField.alertView.title = @"Cannot validate";
            return NO;
        }
        
        id json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        if (!json || error) {
            weakSelf.emailField.alertView.title = @"Cannot validate";
            return NO;
        }

        BOOL isValid = [json[@"is_valid"] boolValue];
        if (!isValid) {
            weakSelf.emailField.alertView.title = @"Invalid email address (online)";
        }
                
        return isValid;
    }];
    
    self.emailField.delegate = self;

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
    self.passwordField.delegate = self;

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
    self.passwordConfirmField.delegate = self;
}

#pragma mark - BZGFormFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
