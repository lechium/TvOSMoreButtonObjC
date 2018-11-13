//
//  UIView+AutoLayout.h
//  TvOSMoreButtonObjC
//
//  Created by Kevin Bradley on 11/12/18.
//  Copyright © 2018 Kevin Bradley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

- (void)pinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsets)insets;
- (void)pinEdgesToSuperviewEdges;
- (instancetype)initWithAutoLayout;
@end
