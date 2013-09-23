//
// BZGFormFieldTests.m
//
// Copyright (c) 2013 Ben Guo
//
// https://github.com/benzguo/BZGFormField
//

#import <XCTest/XCTest.h>
#import "BZGFormField.h"

@interface BZGFormFieldTests : XCTestCase

@property (strong, nonatomic) BZGFormField *formField;

@end

@implementation BZGFormFieldTests

- (void)setUp
{
    [super setUp];
    self.formField = [[BZGFormField alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
}

- (void)tearDown
{
    self.formField = nil;
    [super tearDown];
}

- (void)beginEditing
{
    if ([self.formField becomeFirstResponder]) {
        [self.formField textFieldDidBeginEditing:self.formField.textField];
    }
}

- (void)type
{
    [self.formField textField:self.formField.textField shouldChangeCharactersInRange:(NSRange){0,0} replacementString:@""];
}

- (void)endEditing
{
    if ([self.formField textFieldShouldReturn:self.formField.textField]) {
        [self.formField textFieldDidEndEditing:self.formField.textField];
        [self.formField resignFirstResponder];
    }
}

- (void)testPropertiesAreInitializedToCorrectDefaults
{
    // text field defaults
    XCTAssertTrue([self.formField.textField.text isEqualToString:@""]);
    XCTAssertTrue(self.formField.textField.borderStyle == UITextBorderStyleNone);
    XCTAssertTrue(!self.formField.textField.placeholder);
    XCTAssertTrue(self.formField.textField.delegate == self.formField);

    // default state
    XCTAssertTrue([self.formField formFieldState] == BZGFormFieldStateNone);
}

@end
