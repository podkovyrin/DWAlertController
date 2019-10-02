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

#import "../DWAlertController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 @name The Keyboard Additions protocol.
 */
@protocol DWKeyboardSupport <NSObject>

@optional

/**
 Notifies the view controller that the keyboard will show or hide with specified parameters. This method is called before keyboard animation.
 
 @param height The height of keyboard.
 @param animationDuration The duration of keyboard animation.
 @param animationCurve The animation curve.
 */
- (void)dw_keyboardWillShowOrHideWithHeight:(CGFloat)height
                          animationDuration:(NSTimeInterval)animationDuration
                             animationCurve:(UIViewAnimationCurve)animationCurve;

/**
 The keyboard animation. This method is called inside UIView animation block with the same animation parameters as keyboard animation.
 
 @param height The height of keyboard.
 @param animationDuration The duration of keyboard animation.
 @param animationCurve The animation curve.
 */
- (void)dw_keyboardShowOrHideAnimationWithHeight:(CGFloat)height
                               animationDuration:(NSTimeInterval)animationDuration
                                  animationCurve:(UIViewAnimationCurve)animationCurve;

@end


#pragma mark - Category

/**
 @name The DWAlertController keyboard additions category.
 */
@interface DWAlertController (DWKeyboard) <DWKeyboardSupport>

///----------------------------------------------------------------------------
/// @name State Properties
///----------------------------------------------------------------------------

/**
 YES if keyboard height is > 0.
 */
@property (nonatomic, readonly) BOOL dw_isKeyboardPresented;

/**
 The height of keyboard.
 @note Extracted from `UIKeyboardFrameEndUserInfoKey` on show or sets to 0 on hide.
 */
@property (nonatomic, readonly) CGFloat dw_keyboardHeight;

///----------------------------------------------------------------------------
/// @name Notification Handling
///----------------------------------------------------------------------------

/**
 Starts observing for `UIKeyboardWillShowNotification` and `UIKeyboardWillHideNotification` notifications.
 
 @discussion It is recommended to call this method in `-viewWillAppear:`.
 */
- (void)dw_startObservingKeyboardNotifications;

/**
 Stops observing for `UIKeyboardWillShowNotification` and `UIKeyboardWillHideNotification` notifications.
 
 @discussion It is recommended to call this method in `-viewWillDisappear:`.
 */
- (void)dw_stopObservingKeyboardNotifications;

@end

NS_ASSUME_NONNULL_END
