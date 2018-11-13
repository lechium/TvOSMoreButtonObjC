//
//  NSString+Truncate.m
//  EMLabel
//
//  Created by Mona Zhang on 3/31/15.
//  Updated by Kevin Bradley on 11/12/18
//  Copyright (c) 2015 Mona Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "NSString+Truncate.h"

@implementation NSString (Truncate)

# pragma mark - Helper method

/*
 Returns whether string will fit in given size. Uses `boundingRectWithSize:options:attributes:context` to check if the max height of the string given a constraining width is greater than the height of the given size parameter.
 */


- (BOOL)willFitToSize:(CGSize)size trailingString:(NSString *)trailingString attributes:(NSDictionary *)attributes {
    return [[NSString stringWithFormat:@"%@…%@", self, trailingString] boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                                   attributes:attributes
                                                                                      context:nil].size.height <= size.height;
}

- (NSAttributedString *)attributedStringByTruncatingToSize:(CGSize)size
                                                attributes:(NSDictionary *)attributes
                                            trailingString:(NSString *)trailingString
                                  trailingStringAttributes:(NSDictionary *)trailingStringAttributes {
    
    return [self stringUsingBinarySearchToTruncateToSize:size attributes:attributes trailingString:trailingString trailingStringAttributes:trailingStringAttributes];
    
    
}



#pragma mark - Truncation methods


- (NSAttributedString *)stringUsingBinarySearchToTruncateToSize:(CGSize)size
                                                     attributes:(NSDictionary *)attributes
                                                 trailingString:(NSString *)trailingString
                                       trailingStringAttributes:(NSDictionary *)trailingStringAttributes {
    
    if (![self willFitToSize:size trailingString:@"" attributes:attributes]) {
        
        NSInteger indexOfLastCharacterThatFits = [self binarySearchForStringIndexThatFitsSize:size attributes:attributes minIndex:0 maxIndex:self.length trailingString:trailingString];
        
        //indexOfLastCharacterThatFits-= 3;
        
        NSString *subString = [[self substringToIndex:indexOfLastCharacterThatFits] stringByAppendingString:@"…"];
        
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:subString attributes:attributes];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:trailingString attributes:trailingStringAttributes]];
        return string;
    } else {
        return [[NSAttributedString alloc] initWithString:self attributes:attributes];
    }
    
}


- (NSInteger)binarySearchForStringIndexThatFitsSize:(CGSize)size attributes:(NSDictionary *)attributes minIndex:(NSInteger)minIndex maxIndex:(NSInteger)maxIndex trailingString:(NSString *)trailingString {
    /*
     Invariants:
     - height at minIndex <= size.height
     - height at maxIndex > size.height
     */
    
    NSInteger midIndex = (minIndex + maxIndex) / 2;
    NSString *subString = [self substringWithRange:NSMakeRange(0, midIndex)];
    
    /* Invariant assertions
     assert([[self substringWithRange:NSMakeRange(0, minIndex)] willFitToSize:size trailingString:trailingString attributes:attributes]);
     assert(![[self substringWithRange:NSMakeRange(0, maxIndex)] willFitToSize:size trailingString:trailingString attributes:attributes]);
     */
    
    if (maxIndex - minIndex == 1) {
        return minIndex;
    }
    
    // String is greater than constraining size, start search with minIndex as new maximum
    // The max index will always be greater than the size
    if (![subString willFitToSize:size trailingString:trailingString attributes:attributes]) {
        return [self binarySearchForStringIndexThatFitsSize:size attributes:attributes minIndex:minIndex maxIndex:midIndex trailingString:trailingString];
    }
    // String is less than constraining size, start search with midIndex as new minimum
    // The minimum index will be less than or equal to the size
    else {
        return [self binarySearchForStringIndexThatFitsSize:size attributes:attributes minIndex:midIndex maxIndex:maxIndex trailingString:trailingString];
    }
}

- (BOOL)willFitToSize:(CGSize)size
       ellipsesString:(NSString*)ellipsesString
       trailingString:(NSString *)trailingString
           attributes:(NSDictionary *)attributes {
    return [[NSString stringWithFormat:@"%@%@%@", self, ellipsesString, trailingString] boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX)
                                                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                                   attributes:attributes
                                                                                      context:nil].size.height <= size.height;
}



- (NSAttributedString *)attributedStringByTruncatingToSize:(CGSize)size
                                            ellipsesString:(NSString *)ellipsesString
                                            trailingString:(NSString *)trailingString
                                                attributes:(NSDictionary *)attributes
                                  trailingStringAttributes:(NSDictionary *)trailingStringAttributes {
    
    return [self stringUsingBinarySearchToTruncateToSize:size ellipsesString:ellipsesString attributes:attributes trailingString:trailingString trailingStringAttributes:trailingStringAttributes];
    
    
}


#pragma mark - Truncation methods

/*
 TruncationModeBinarySearch - using 0 and N as starting indices, where N is the length of the string, perform a binary search that maintains the invariants that:
 
 - height at minIndex <= size.height
 - height at maxIndex > size.height
 
 Returns minIndex when minIndex and maxIndex are adjacent
 
 Performance: log(N)
 */

- (NSAttributedString *)stringUsingBinarySearchToTruncateToSize:(CGSize)size
                                                 ellipsesString:(NSString*)ellipsesString
                                                     attributes:(NSDictionary *)attributes
                                                 trailingString:(NSString *)trailingString
                                       trailingStringAttributes:(NSDictionary *)trailingStringAttributes {
    
    NSInteger indexOfLastCharacterThatFits = [self binarySearchForStringIndexThatFitsSize:size attributes:attributes minIndex:0 maxIndex:self.length trailingString:trailingString ellipsesString:ellipsesString];
    
    NSString *subString = [[self substringToIndex:indexOfLastCharacterThatFits] stringByAppendingString:ellipsesString];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:subString attributes:attributes];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:trailingString attributes:trailingStringAttributes]];
    return string;
}


- (NSInteger)binarySearchForStringIndexThatFitsSize:(CGSize)size
                                         attributes:(NSDictionary *)attributes
                                           minIndex:(NSInteger)minIndex
                                           maxIndex:(NSInteger)maxIndex
                                     trailingString:(NSString *)trailingString
                                     ellipsesString:(NSString *)ellipsesString {
    /*
     Invariants:
     - height at minIndex <= size.height
     - height at maxIndex > size.height
     */
    
    NSInteger midIndex = (minIndex + maxIndex) / 2;
    NSString *subString = [self substringWithRange:NSMakeRange(0, midIndex)];
    
    /* Invariant assertions
     assert([[self substringWithRange:NSMakeRange(0, minIndex)] willFitToSize:size trailingString:trailingString attributes:attributes]);
     assert(![[self substringWithRange:NSMakeRange(0, maxIndex)] willFitToSize:size trailingString:trailingString attributes:attributes]);
     */
    
    if (maxIndex - minIndex == 1) {
        return minIndex;
    }
    
    // String is greater than constraining size, start search with minIndex as new maximum
    // The max index will always be greater than the size
    if (![subString willFitToSize:size ellipsesString:ellipsesString trailingString:trailingString attributes:attributes]) {
        return [self binarySearchForStringIndexThatFitsSize:size attributes:attributes minIndex:minIndex maxIndex:midIndex trailingString:trailingString ellipsesString:ellipsesString];
    }
    // String is less than constraining size, start search with midIndex as new minimum
    // The minimum index will be less than or equal to the size
    else {
        return [self binarySearchForStringIndexThatFitsSize:size attributes:attributes minIndex:midIndex maxIndex:maxIndex trailingString:trailingString ellipsesString:ellipsesString];
    }
}


@end
