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

#ifndef DWAlertInternalConstants_h
#define DWAlertInternalConstants_h

#import <UIKit/UIKit.h>

#import "../DWAlertAppearanceMode.h"

// Default iOS UIAlertController's constants

static CGFloat const DWAlertViewWidth = 270.0;

static CGFloat const DWAlertViewContentHorizontalPadding = 16.0;
static CGFloat const DWAlertViewContentVerticalPadding = 20.0;

static CGFloat const DWAlertViewCornerRadius = 13.0;
static CGFloat const DWAlertViewActionsMultilineMinimumHeight = 66.0;

static CGFloat const DWAlertTransitionAnimationDuration = 0.4;
static CGFloat const DWAlertTransitionAnimationDampingRatio = 1.0;
static CGFloat const DWAlertTransitionAnimationInitialVelocity = 0.0;
static UIViewAnimationOptions const DWAlertTransitionAnimationOptions = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction;

static CGFloat const DWAlertInplaceTransitionAnimationDuration = 0.4;
static CGFloat const DWAlertInplaceTransitionAnimationDampingRatio = 1.0;
static CGFloat const DWAlertInplaceTransitionAnimationInitialVelocity = 0.0;
static UIViewAnimationOptions const DWAlertInplaceTransitionAnimationOptions = UIViewAnimationOptionCurveEaseInOut;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused"

static BOOL DWAlertHasTopNotch(void) {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0.0;
    }

    return NO;
}

static CGFloat DWAlertViewVerticalPadding(CGFloat minInset, BOOL keyboardVisible) {
    CGFloat padding = 0.0;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        if (keyboardVisible) {
            padding = 20.0;
        }
        else {
            padding = 24.0;
        }
    }
    else {
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            const BOOL hasTopNotch = DWAlertHasTopNotch();
            if (keyboardVisible) {
                padding = hasTopNotch ? minInset : 20.0;
            }
            else {
                padding = hasTopNotch ? 61.0 : 24.0;
            }
        }
        else {
            padding = 8.0;
        }
    }

    return MAX(padding, minInset);
}

static CGFloat DWAlertViewSeparatorSize(void) {
    return 1.0 / [UIScreen mainScreen].scale;
}

static CGFloat DWAlertViewActionButtonMinHeight(UIContentSizeCategory category) {
    if ([category isEqualToString:UIContentSizeCategoryExtraLarge]) {
        return 47.0;
    }
    else if ([category isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
        return 49.5;
    }
    else if ([category isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
        return 51.5;
    }
    else if ([category isEqualToString:UIContentSizeCategoryAccessibilityMedium]) {
        return 67.5;
    }
    else if ([category isEqualToString:UIContentSizeCategoryAccessibilityLarge]) {
        return 79.5;
    }
    else if ([category isEqualToString:UIContentSizeCategoryAccessibilityExtraLarge]) {
        return 96.0;
    }
    else if ([category isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraLarge]) {
        return 112.5;
    }
    else if ([category isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge]) {
        return 125.5;
    }
    else {
#ifdef DEBUG
        const BOOL isKnownCategory =
            [category isEqualToString:UIContentSizeCategoryExtraSmall] ||
            [category isEqualToString:UIContentSizeCategorySmall] ||
            [category isEqualToString:UIContentSizeCategoryMedium] ||
            [category isEqualToString:UIContentSizeCategoryLarge];
        if (@available(iOS 10.0, *)) {
            NSCAssert([category isEqualToString:UIContentSizeCategoryUnspecified] ||
                          isKnownCategory,
                      @"Unknown category");
        }
        else {
            NSCAssert(isKnownCategory,
                      @"Unknown category");
        }
#endif /* DEBUG */
        return 44.5;
    }
}

static CGFloat DWAlertViewActionButtonCurrentMinHeight(void) {
    const UIContentSizeCategory category = [UIApplication sharedApplication].preferredContentSizeCategory;
    return DWAlertViewActionButtonMinHeight(category);
}

static CGFloat DWAlertViewActionButtonTitlePadding(UIContentSizeCategory category) {
    if ([category isEqualToString:UIContentSizeCategoryExtraLarge]) {
        return 12.0;
    }
    else if ([category isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
        return 12.0;
    }
    else if ([category isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
        return 12.0;
    }
    else if ([category isEqualToString:UIContentSizeCategoryAccessibilityMedium]) {
        return 16.0;
    }
    else if ([category isEqualToString:UIContentSizeCategoryAccessibilityLarge]) {
        return 16.0;
    }
    else if ([category isEqualToString:UIContentSizeCategoryAccessibilityExtraLarge]) {
        return 16.0;
    }
    else if ([category isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraLarge]) {
        return 16.0;
    }
    else if ([category isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge]) {
        return 16.0;
    }
    else {
#ifdef DEBUG
        const BOOL isKnownCategory =
            [category isEqualToString:UIContentSizeCategoryExtraSmall] ||
            [category isEqualToString:UIContentSizeCategorySmall] ||
            [category isEqualToString:UIContentSizeCategoryMedium] ||
            [category isEqualToString:UIContentSizeCategoryLarge];
        if (@available(iOS 10.0, *)) {
            NSCAssert([category isEqualToString:UIContentSizeCategoryUnspecified] ||
                          isKnownCategory,
                      @"Unknown category");
        }
        else {
            NSCAssert(isKnownCategory,
                      @"Unknown category");
        }
#endif /* DEBUG */
        return 12.0;
    }
}

API_AVAILABLE(ios(12.0))
static DWAlertAppearanceMode DWAlertAppearanceModeForUIInterfaceStyle(UIUserInterfaceStyle style) {
    switch (style) {
        case UIUserInterfaceStyleUnspecified:
            return DWAlertAppearanceModeAutomatic;
        case UIUserInterfaceStyleLight:
            return DWAlertAppearanceModeLight;
        case UIUserInterfaceStyleDark:
            return DWAlertAppearanceModeDark;
    }
}

static UIColor *DWAlertViewNormalTextColor() {
    return [UIColor systemBlueColor];
}

static UIColor *DWAlertViewDisabledTextColor() {
    return [UIColor systemGrayColor];
}

static UIColor *DWAlertViewDestructiveTextColor() {
    return [UIColor systemRedColor];
}

static UIColor *DWAlertViewBackgroundViewColor() {
    return [UIColor colorWithWhite:1.0 alpha:0.1];
}

static UIColor *DWAlertViewSeparatorColor(DWAlertAppearanceMode appearanceMode) {
    if (appearanceMode == DWAlertAppearanceModeDark) {
        return [UIColor whiteColor];
    }
    else {
        return [UIColor colorWithWhite:0.75 alpha:1.0];
    }
}

static UIColor *DWAlertViewActionTouchHighlightColor(DWAlertAppearanceMode appearanceMode) {
    if (appearanceMode == DWAlertAppearanceModeDark) {
        return [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    else {
        return [UIColor whiteColor];
    }
}

static UIBlurEffect *DWAlertViewBlurEffect(DWAlertAppearanceMode appearanceMode) {
    if (appearanceMode == DWAlertAppearanceModeDark) {
        return [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    else {
        return [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    }
}

#pragma clang diagnostic pop

#endif /* DWAlertInternalConstants_h */
