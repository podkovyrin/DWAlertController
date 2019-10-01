//
//  Created by Andrew Podkovyrin
//  Copyright © 2018 Dash Core Group. All rights reserved.
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

#import <UIKit/UIKit.h>

#import "DWAlertAction.h"
#import "DWAlertAppearanceMode.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Custom implementation of `UIAlertController` with a child controller instead of title / message.
 */
@interface DWAlertController : UIViewController <UIAppearance>

/**
 Configure alert with subclass of `UIViewController`.
 To re-set the content controller during presenting the alert use
 `performTransitionToContentController:animated:` method.
 
 @param contentController The controller to display. Any subclass of `UIViewController`.
 @return Configured DWAlertController object
 */
- (instancetype)initWithContentController:(__kindof UIViewController *)contentController NS_DESIGNATED_INITIALIZER;

/**
 Convinience initializer
 */
+ (instancetype)alertControllerWithContentController:(__kindof UIViewController *)contentController;

/**
 Child content controller. Any subclass of `UIViewController`.
 */
@property (readonly, nullable, strong, nonatomic) __kindof UIViewController *contentController;

/**
 Replace current content controller with a new controller.
 The content controller must have already been set.

 @param controller New controller to display
 @param animated Wheter transition should be animated. Used cross-fade animation.
 */
- (void)performTransitionToContentController:(UIViewController *)controller animated:(BOOL)animated NS_SWIFT_NAME(performTransition(toContentController:animated:));

@property (readonly, copy, nonatomic) NSArray<DWAlertAction *> *actions;
- (void)addAction:(DWAlertAction *)action;
- (void)setupActions:(NSArray<DWAlertAction *> *)actions;

/**
 Appearance mode of alert.
 The default value is `automatic`. On iOS 13 follows user's Dark Mode setting. On iOS 12 or lower acts as light.
 
 Setting this property to non-default value overrides Dark Mode setting on iOS 13. However, for instance, if
 the light appearance alert is shown in the dark environment it won't look good when the action button is pressed
 since `UIVibrancyEffect` is used to provide highlighted state of the action buttons.
 */
@property (nonatomic, assign) DWAlertAppearanceMode appearanceMode;

/**
 The preferred action for the user to take from an alert.
 
 When you specify a preferred action, the alert controller highlights the text of that action to give it emphasis. (If the alert also contains a cancel button, the preferred action receives the highlighting instead of the cancel button.) If the iOS device is connected to a physical keyboard, pressing the Return key triggers the preferred action.
 The action object you assign to this property must have already been added to the alert controller’s list of actions. Assigning an object to this property before adding it with the `addAction:` method is a programmer error.
 The default value of this property is nil.
 */
@property (nullable, strong, nonatomic) DWAlertAction *preferredAction;

/**
 The text color of active action button
 */
@property (strong, nonatomic) UIColor *normalTintColor UI_APPEARANCE_SELECTOR;

/**
 The text color of disable action button
 */
@property (strong, nonatomic) UIColor *disabledTintColor UI_APPEARANCE_SELECTOR;

/**
 The text color of active destructive action button
 */
@property (strong, nonatomic) UIColor *destructiveTintColor UI_APPEARANCE_SELECTOR;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
