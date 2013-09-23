//
// BZGTooltip.h
//
// Copyright (c) 2013 Ben Guo
//
// https://github.com/benzguo/BZGFormField
//


#import <UIKit/UIKit.h>

@interface BZGTooltip : UIView

+ (BZGTooltip *)sharedTooltip;
- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView;
- (void)setTooltipVisible:(BOOL)tooltipVisible animated:(BOOL)animated;

@end
