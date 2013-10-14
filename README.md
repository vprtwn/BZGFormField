# BZGFormField

`BZGFormField` is a text field with a validity indicator. UI/UX inspired by [@muffs](https://github.com/muffs)

![alt tag](https://raw.github.com/benzguo/BZGFormField/master/Screenshots/1.png)

The left indicator changes color based on the validity of the field's text - just pass the field a text validation block:

```objective-c
[self.passwordField setTextValidationBlock:^BOOL(NSString *text) {
    return (text.length >= 8);
}];
```

![alt tag](https://raw.github.com/benzguo/BZGFormField/master/Screenshots/2.png)

When the text field returns, the indicator expands and becomes tappable.

![alt tag](https://raw.github.com/benzguo/BZGFormField/master/Screenshots/3.png)

When the indicator is tapped, an alert view is displayed - you can configure the alert view in the text validation block.

```objective-c
__weak RootViewController *weakSelf = self;
[self.passwordField setTextValidationBlock:^BOOL(NSString *text) {
    if (text.length < 8) {
        weakSelf.passwordField.alertView.title = @"Password is too short";
        return NO;
    } else {
        return YES;
    }
}];
```

![alt tag](https://raw.github.com/benzguo/BZGFormField/master/Screenshots/4.png)

## Installation

* If you're using cocoapods, add ```pod 'BZGFormField'``` to your Podfile. Otherwise, add `BZGFormField/BZGFormField.h` and `BZGFormField/BZGFormField.m` to your project.

## Usage

* Check out the sample Xcode project in `Example`

