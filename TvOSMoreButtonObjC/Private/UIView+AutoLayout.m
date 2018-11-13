//
//  UIView+AutoLayout.m
//  TvOSMoreButtonObjC
//
//  Created by Kevin Bradley on 11/12/18.
//  Copyright © 2018 Kevin Bradley. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (instancetype)initWithAutoLayout //dont want to conflict with PureLayout
{
    self = [self init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)pinEdgesToSuperviewEdges {
    
    [self pinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)pinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsets)insets {
    
    if (self.superview == nil) return;
    self.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *topConstraint = [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:insets.top];
    NSLayoutConstraint *bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor constant:-insets.bottom];
    NSLayoutConstraint *leftConstraint = [self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:insets.left];
    NSLayoutConstraint *rightConstraint = [self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor constant:-insets.right];
    [self.superview addConstraints:@[topConstraint,bottomConstraint, leftConstraint, rightConstraint]];
    
}

@end
