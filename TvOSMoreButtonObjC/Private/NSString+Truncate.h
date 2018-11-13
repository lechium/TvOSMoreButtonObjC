//
//  NSString+Truncate.h
//  EMLabel
//
//  Created by Mona Zhang on 3/31/15.
//  Updated by Kevin Bradley on 11/12/18
//  Copyright (c) 2015 Mona Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (Truncate)


- (NSAttributedString *)attributedStringByTruncatingToSize:(CGSize)size
                                            ellipsesString:(NSString *)ellipsesString
                                            trailingString:(NSString *)trailingString
                                                attributes:(NSDictionary *)attributes
                                  trailingStringAttributes:(NSDictionary *)trailingStringAttributes;



- (NSAttributedString *)attributedStringByTruncatingToSize:(CGSize)size
                                                attributes:(NSDictionary *)attributes
                                            trailingString:(NSString *)trailingString
                                  trailingStringAttributes:(NSDictionary *)trailingStringAttributes;



@end
