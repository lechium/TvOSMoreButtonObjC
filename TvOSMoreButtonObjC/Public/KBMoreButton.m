//
//  KBMoreButton.m
//  TvOSMoreButtonObjC
//
//  Created by Kevin Bradley on 11/11/18.
//  Copyright © 2018 Kevin Bradley. All rights reserved.
//

#import "KBMoreButton.h"
#import "UIView+AutoLayout.h"
#import "NSString+Truncate.h"
#import "KBBundleLoader.h"

@interface KBMoreButton()
{
    NSTextAlignment _textAlignment;
}
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *focusedView;
@property (nonatomic, strong) UIGestureRecognizer *selectGestureRecognizer;
@property (readwrite, assign) BOOL isFocusable;

@end

@implementation KBMoreButton


- (void)setDefaults {
    
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:25];
    self.ellipsesString = @"…";
    self.trailingText = [NSLocalizedStringFromTableInBundle(@"TvOSMoreButton.More.Text", nil, KBBundleLoader.mainBundle, @"Text that appears after a long description in a label.") uppercaseString];
    self.trailingTextColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.trailingTextfont = [UIFont boldSystemFontOfSize:18];
    self.pressAnimationDuration = 0.1;
    self.labelMargin = 12.0f;
    self.cornerRadius = 10.0;
    self.focusedScaleFactor = 1.05f;
    self.shadowRadius = 10.0;
    self.shadowColor = [UIColor blackColor].CGColor;
    self.focusedShadowOffset = CGSizeMake(0, 27);
    self.focusedViewAlpha = 0.75;
    self.focusedShadowOpacity = 0.75;
    
}

- (NSDictionary *)textAttributes {
    
    return @{NSForegroundColorAttributeName: self.textColor, NSFontAttributeName: self.font};
    
}

- (NSDictionary *)trailingTextAttributes {
    
    return @{NSForegroundColorAttributeName: self.trailingTextColor, NSFontAttributeName: self.trailingTextfont};
    
}

- (NSTextAlignment)textAlignment {
    
    return _textAlignment;
    
}

- (void)setTextAlignment:(NSTextAlignment)alignment {
    
    _textAlignment = alignment;
    self.label.textAlignment = _textAlignment;
    
}

- (void)dealloc {
    
    [self unregisterFromKVO];
    
}

#pragma mark KVO

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"trailingText", @"ellipsesString", @"trailingTextColor", @"trailingTextfont",@"font", @"textColor", @"text", nil];
}


- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateUI];
}


- (void)setupObservers {

    [self registerForKVO];
    
    
}

#pragma mark - init

- (id)initWithAutoLayout {
    
    self = [super initWithAutoLayout];
    [self setUpUI];
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    [self setUpUI];
    return self;
    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self setUpUI];
    return self;
    
}

- (CGSize)intrinsicContentSize {
    
    return self.label.intrinsicContentSize;
}

- (BOOL)canBecomeFocused {
    
    return self.isFocusable;
    
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    
    [coordinator addCoordinatedAnimations:^{
        
        if (self.isFocused) {
            [self applyFocusedAppearance];
        } else {
            [self applyUnfocusedAppearance];
        }
        
    } completion:^{
        
    }];
    
}

- (void)updateUI {
    
    [self truncateAndUpdateText];
}

#pragma mark - Presses

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    [super pressesBegan:presses withEvent:event];
    
    for (UIPress *item in presses) {
        
        if (item.type == UIPressTypeSelect){
            [self applyPressDownAppearance];
        }
        
    }
}

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    [super pressesEnded:presses withEvent:event];
    
    for (UIPress *item in presses) {
        
        if (item.type == UIPressTypeSelect){
            [self applyPressUpAppearance];
        }
        
    }
}

- (void)pressesCancelled:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    
    [super pressesCancelled:presses withEvent:event];
    
    for (UIPress *item in presses) {
        
        if (item.type == UIPressTypeSelect){
            [self applyPressUpAppearance];
        }
        
    }
}

- (void)setUpUI {
    
    [self setUpView];
    [self setUpFocusedView];
    [self setUpLabel];
    [self setUpSelectGestureRecognizer];
    [self applyUnfocusedAppearance];
    
    
}

- (void)setUpView {
    
    [self setDefaults]; //objc specific
    [self setupObservers]; //objc specific
    self.userInteractionEnabled = true;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = false;
}

- (void)setUpLabel {
    
    self.label = [UILabel new];
    self.label.numberOfLines = 0;
    [self addSubview:self.label];
    
    UIEdgeInsets labelInsets = UIEdgeInsetsMake(self.labelMargin, self.labelMargin, self.labelMargin, self.labelMargin);
    [self.label pinEdgesToSuperviewEdgesWithInsets:labelInsets];
    
}

- (void)setUpFocusedView {
    
    self.focusedView = [[UIView alloc] initWithAutoLayout];
    self.focusedView.layer.cornerRadius = self.cornerRadius;
    self.focusedView.layer.shadowColor = self.shadowColor;
    self.focusedView.layer.shadowRadius = self.shadowRadius;
    [self addSubview:self.focusedView];
    [self.focusedView pinEdgesToSuperviewEdges];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.alpha = self.focusedViewAlpha;
    blurView.layer.cornerRadius = self.cornerRadius;
    blurView.layer.masksToBounds = true;
    [self.focusedView addSubview:blurView];
    [blurView pinEdgesToSuperviewEdges];
 
}

- (void)setUpSelectGestureRecognizer {
    
    self.selectGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGestureWasPressed:)];
    self.selectGestureRecognizer.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeSelect]];
    [self addGestureRecognizer:self.selectGestureRecognizer];
}


- (void)selectGestureWasPressed:(UIGestureRecognizer *)recognizer {
    
    if (self.buttonWasPressed){
        self.buttonWasPressed(self.text);
    }

}

#pragma mark - Focus Appearance

- (void)applyFocusedAppearance {
    
    self.transform = CGAffineTransformMakeScale(self.focusedScaleFactor, self.focusedScaleFactor);
    self.focusedView.layer.shadowOffset = self.focusedShadowOffset;
    self.focusedView.layer.shadowOpacity = self.focusedShadowOpacity;
    self.focusedView.alpha = 1;
    
    
}

- (void)applyUnfocusedAppearance{
    
    self.transform = CGAffineTransformIdentity;
    self.focusedView.layer.shadowOffset = CGSizeZero;
    self.focusedView.layer.shadowOpacity = 0;
    self.focusedView.alpha = 0;
    
}

- (void)applyPressUpAppearance {
    
    [UIView animateWithDuration:self.pressAnimationDuration animations:^{
        
        [self applyFocusedAppearance];
        
    }];
    
}

- (void)applyPressDownAppearance {
    
    [UIView animateWithDuration:self.pressAnimationDuration animations:^{
       
        self.transform = CGAffineTransformIdentity;
        self.focusedView.layer.shadowOffset = CGSizeZero;
        self.focusedView.layer.shadowOpacity = 0;
        
    }];
    
}

#pragma mark - Truncating Text

- (void)truncateAndUpdateText {
    
    self.label.text = self.text;
    if (self.text.length == 0) {
        return;
    }
    
    [self layoutIfNeeded];
    CGSize labelSize = self.label.bounds.size;
    NSString *trailingText = [NSString stringWithFormat:@" %@", self.trailingText];
    
    self.label.attributedText = [self.text attributedStringByTruncatingToSize:labelSize ellipsesString:self.ellipsesString trailingString:trailingText attributes:self.textAttributes trailingStringAttributes:self.trailingTextAttributes];
    
    self.isFocusable = true;
    
}


@end
