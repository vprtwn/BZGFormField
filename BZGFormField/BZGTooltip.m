//
// BZGTooltip.m
//
// Copyright (c) 2013 Ben Guo
//
// https://github.com/benzguo/BZGFormField
//


#import "BZGTooltip.h"

@implementation BZGTooltip

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        UIView *superview = [[[UIApplication sharedApplication] windows] lastObject]; // frontmost window
        [superview addSubview:self];
    }
    return self;
}

+ (BZGTooltip *)sharedTooltip
{
    static BZGTooltip *_sharedTooltip = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTooltip = [[self alloc] init];
        UIGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tooltipTapAction)];
        _sharedTooltip.backgroundColor = [UIColor grayColor];
        [_sharedTooltip addGestureRecognizer:tapGR];
    });
    return _sharedTooltip;

}

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView
{
    CGRect targetFrame = targetView.bounds;
    targetFrame.size.height = 10;
    targetFrame.origin.y = CGRectGetMaxY(targetView.bounds);
    self.frame = targetFrame;
    self.frame = [self convertRect:targetFrame toView:self.window];
}

- (void)setTooltipVisible:(BOOL)tooltipVisible animated:(BOOL)animated
{
    void(^animations)() = ^{
        if (tooltipVisible) {
            self.hidden = NO;
            self.alpha = 1.0;
        } else {
            self.alpha = 0.0;
        }
    };

    void (^completion)(BOOL) = ^(BOOL finished){
        if (!tooltipVisible) {
            self.hidden = YES;
        }
    };

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:animations completion:completion];

}

- (void)tooltipTapAction
{
    [self setTooltipVisible:NO animated:YES];
}

@end
