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

#import <UIKit/UIKit.h>

#import "../DWAlertAppearanceMode.h"

NS_ASSUME_NONNULL_BEGIN

@class DWAlertAction;
@class DWAlertView;

@protocol DWAlertViewDelegate <NSObject>

- (void)alertView:(DWAlertView *)alertView didAction:(DWAlertAction *)action;

@end

/**
 Internal view of DWAlertController
 */
@interface DWAlertView : UIView

/**
 A Class to use as custom action view.
 Must be a subclass of `DWAlertViewActionBaseView`
 */
@property (null_resettable, strong, nonatomic) Class actionViewClass;
@property (nullable, weak, nonatomic) id<DWAlertViewDelegate> delegate;
@property (nullable, strong, nonatomic) DWAlertAction *preferredAction;

@property (nonatomic, assign) DWAlertAppearanceMode appearanceMode;

@property (strong, nonatomic) UIColor *normalTintColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *disabledTintColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *destructiveTintColor UI_APPEARANCE_SELECTOR;

- (void)setupChildView:(UIView *)childView;
- (void)addAction:(DWAlertAction *)action;
- (void)resetActionsState;
- (void)removeAllActions;

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
