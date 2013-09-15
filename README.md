# BZGFormField

`BZGFormField` is a text field with a validity indicator.

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

* Drag the `BZGFormField/BZGFormField` folder into your project.

## Usage

* See sample Xcode project in `/Example`

## Roadmap

* make a Podspec
* add more configurable things
