//
//  Created by Andrew Podkovyrin
//  Copyright © 2019 Dash Core Group. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "DWAlertViewActionButton.h"

#import "DWAlertInternalConstants.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - UIFont Helper

@implementation UIFont (DWAlertViewActionButtonHelper)

+ (UIFont *)dw_alertTitleFont {
    return [self dw_alert_actionFontForTextStyle:UIFontTextStyleBody];
}

+ (UIFont *)dw_alertPreferredTitleFont {
    return [self dw_alert_actionFontForTextStyle:UIFontTextStyleHeadline];
}

#pragma mark - Private

// Don't scale font less than Default (Large) content size category (as UIAlertController does)
+ (BOOL)dw_alert_shouldUsePreferredFontForTextStyle:(UIContentSizeCategory)category {
    if (@available(iOS 10.0, *)) {
        if ([category isEqualToString:UIContentSizeCategoryUnspecified]) {
            return NO;
        }
    }

    if ([category isEqualToString:UIContentSizeCategoryExtraSmall] ||
        [category isEqualToString:UIContentSizeCategorySmall] ||
        [category isEqualToString:UIContentSizeCategoryMedium]) {
        return NO;
    }

    return YES;
}

+ (UIFont *)dw_alert_actionFontForTextStyle:(UIFontTextStyle)textStyle {
    const UIContentSizeCategory category = [UIApplication sharedApplication].preferredContentSizeCategory;
    const BOOL shouldUsePreferred = [self dw_alert_shouldUsePreferredFontForTextStyle:category];
    if (shouldUsePreferred) {
        return [UIFont preferredFontForTextStyle:textStyle];
    }
    else {
        if (@available(iOS 10.0, *)) {
            const UIContentSizeCategory defaultCategory = UIContentSizeCategoryLarge;
            UITraitCollection *trait =
                [UITraitCollection traitCollectionWithPreferredContentSizeCategory:defaultCategory];
            return [UIFont preferredFontForTextStyle:textStyle compatibleWithTraitCollection:trait];
        }
        else {
            // Minor case: iOS 9 and user's category less than default.
            // Since we are using body or headline styles which are both have size of 17 in
            // the default category lets just hardcode it 🤦‍♂️.
            return [[UIFont preferredFontForTextStyle:textStyle] fontWithSize:17.0];
        }
    }
}

@end

#pragma mark - Button

static NSLineBreakMode const LineBreakMode = NSLineBreakByTruncatingMiddle;
static NSTextAlignment const TextAlignment = NSTextAlignmentCenter;
static CGFloat const MinimumScaleFactor = 0.58;

@interface DWAlertViewActionButton ()

@property (readonly, strong, nonatomic) UILabel *titleLabel;
@property (readonly, strong, nonatomic) NSLayoutConstraint *topTitleContraint;
@property (readonly, strong, nonatomic) NSLayoutConstraint *bottomTitleConstraint;

@end

@implementation DWAlertViewActionButton

- (instancetype)initWithAlertAction:(DWAlertAction *)alertAction {
    self = [super initWithAlertAction:alertAction];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.lineBreakMode = LineBreakMode;
        titleLabel.textAlignment = TextAlignment;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumScaleFactor = MinimumScaleFactor;
        titleLabel.text = self.alertAction.title;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;

        NSLayoutConstraint *topTitleContraint =
            [titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor];
        _topTitleContraint = topTitleContraint;
        NSLayoutConstraint *bottomTitleConstraint =
            [titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
        _bottomTitleConstraint = bottomTitleConstraint;
        [NSLayoutConstraint activateConstraints:@[
            topTitleContraint,
            [titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            bottomTitleConstraint,
            [titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        ]];

        [self updateEnabledState];
        [self updateTitlePadding];
    }
    return self;
}

- (void)setPreferred:(BOOL)preferred {
    [super setPreferred:preferred];

    if (preferred) {
        self.titleLabel.font = [UIFont dw_alertPreferredTitleFont];
    }
    else {
        self.titleLabel.font = [UIFont dw_alertTitleFont];
    }
}

- (void)setNormalTintColor:(UIColor *)normalTintColor {
    [super setNormalTintColor:normalTintColor];

    if (self.alertAction.style != DWAlertActionStyleDestructive) {
        self.titleLabel.highlightedTextColor = normalTintColor;
    }
}

- (void)setDisabledTintColor:(UIColor *)disabledTintColor {
    [super setDisabledTintColor:disabledTintColor];

    self.titleLabel.textColor = disabledTintColor;
}

- (void)setDestructiveTintColor:(UIColor *)destructiveTintColor {
    [super setDestructiveTintColor:destructiveTintColor];

    if (self.alertAction.style == DWAlertActionStyleDestructive) {
        self.titleLabel.highlightedTextColor = destructiveTintColor;
    }
}

- (void)updateForCurrentContentSizeCategory {
    self.preferred = self.preferred;

    [self updateTitlePadding];
}

- (void)updateEnabledState {
    [super updateEnabledState];

    self.titleLabel.highlighted = self.alertAction.enabled;
}

#pragma mark - Private

- (void)updateTitlePadding {
    NSParameterAssert(self.topTitleContraint);
    NSParameterAssert(self.bottomTitleConstraint);

    const UIContentSizeCategory category = [UIApplication sharedApplication].preferredContentSizeCategory;
    const CGFloat padding = DWAlertViewActionButtonTitlePadding(category);
    self.topTitleContraint.constant = padding;
    self.bottomTitleConstraint.constant = -padding;
}

@end

NS_ASSUME_NONNULL_END
