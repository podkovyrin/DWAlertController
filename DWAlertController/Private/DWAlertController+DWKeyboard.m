//
//  Created by Andrew Podkovyrin
//  Copyright © 2015-2019 Andrew Podkovyrin. All rights reserved.
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

#import "DWAlertController+DWKeyboard.h"

#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@implementation DWAlertController (DWKeyboard)

#pragma mark - Properties

- (BOOL)dw_isKeyboardPresented {
    return self.dw_keyboardHeight > 0.0;
}

- (CGFloat)dw_keyboardHeight {
    NSNumber *keyboardHeightNumber = objc_getAssociatedObject(self, @selector(dw_keyboardHeight));
    return keyboardHeightNumber.floatValue;
}

- (void)dw_setKeyboardHeight:(CGFloat)keyboardHeight {
    objc_setAssociatedObject(self, @selector(dw_keyboardHeight), @(keyboardHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Notifications

- (void)dw_startObservingKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dw_keyboardWillShowOrHideNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dw_keyboardWillShowOrHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dw_stopObservingKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Private

- (void)dw_keyboardWillShowOrHideNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;

    // When keyboard is hiding, the height value from UIKeyboardFrameEndUserInfoKey sometimes is incorrect
    // Sets it manually to 0
    const CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    const CGRect convertedRect = [self.view convertRect:keyboardFrame fromView:nil];
    const BOOL isShowNotification = [notification.name isEqualToString:UIKeyboardWillShowNotification];
    const CGFloat keyboardHeight = isShowNotification ? CGRectGetHeight(convertedRect) : 0.0;

    [self dw_setKeyboardHeight:keyboardHeight];


    const NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    const UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    [self dw_keyboardWillShowOrHideWithHeight:keyboardHeight
                            animationDuration:animationDuration
                               animationCurve:animationCurve];

    [UIView beginAnimations:@"DWAlertController+Keyboard-Animation" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];

    [self dw_keyboardShowOrHideAnimationWithHeight:keyboardHeight
                                 animationDuration:animationDuration
                                    animationCurve:animationCurve];

    [UIView commitAnimations];
}

@end

NS_ASSUME_NONNULL_END
