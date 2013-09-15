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
{
    BZGFormField *formField;
}

@end

@implementation BZGFormFieldTests

- (void)setUp
{
    [super setUp];
    formField = [[BZGFormField alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
}

- (void)tearDown
{
    formField = nil;
    [super tearDown];
}

- (void)testInitialization
{
    // alert view
    XCTAssertTrue([formField.alertView.title isEqualToString:@""]);
    XCTAssertTrue([formField.alertView.message isEqualToString:@""]);
    XCTAssertTrue([[formField.alertView buttonTitleAtIndex:formField.alertView.cancelButtonIndex]
                   isEqualToString:@"Ok"]);
    XCTAssertTrue(formField.alertView.delegate == formField);

    // text field
    XCTAssertTrue([formField.textField.text isEqualToString:@""]);
    XCTAssertTrue(formField.textField.borderStyle == UITextBorderStyleNone);
    XCTAssertTrue(!formField.textField.placeholder);
    XCTAssertTrue(formField.textField.delegate == formField);

    // state
    XCTAssertTrue([formField formFieldState] == BZGFormFieldStateNone);
    XCTAssertTrue([formField leftIndicatorState] == BZGLeftIndicatorStateInactive);
}


@end
