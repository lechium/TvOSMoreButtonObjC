//
//  KBBundleLoader.m
//  TvOSMoreButtonObjC
//
//  Created by Kevin Bradley on 11/12/18.
//  Copyright © 2018 Kevin Bradley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBBundleLoader.h"
#import "KBMoreButton.h"

@implementation KBBundleLoader

+ (NSBundle *) mainBundle {
    static NSBundle *_mainBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSBundle *podBundle = [NSBundle bundleForClass:[KBBundleLoader class]];
        NSURL *url = [podBundle URLForResource:NSStringFromClass([KBMoreButton class]) withExtension:@"bundle"];
        if (url) {
            NSBundle *resourceBundle = [NSBundle bundleWithURL:url];
            NSString *languageCode = [[NSLocale currentLocale] languageCode];
            NSURL *languageURL = [resourceBundle URLForResource:languageCode withExtension:@"lproj"];
            if (languageURL) {
                _mainBundle = [NSBundle bundleWithURL:languageURL];
            } else {
                languageURL = [resourceBundle URLForResource:@"en" withExtension:@"lproj"];
                if (languageURL) {
                    _mainBundle = [NSBundle bundleWithURL:languageURL];
                } else {
                    _mainBundle = [NSBundle mainBundle];
                }
            }
            
        } else {
            _mainBundle = [NSBundle mainBundle];
        }
    });
    
    return _mainBundle;
}


@end
