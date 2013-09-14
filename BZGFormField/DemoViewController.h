//
//  DemoViewController.h
//  BZGFormField
//
//  Created by Ben Guo on 9/14/13.
//  Copyright (c) 2013 BZG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BZGFormField;

@interface DemoViewController : UIViewController

@property (weak, nonatomic) IBOutlet BZGFormField *emailField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordField;
@property (weak, nonatomic) IBOutlet BZGFormField *passwordConfirmField;

@end
