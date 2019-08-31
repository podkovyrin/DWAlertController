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

#import "DWAlertViewActionBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class DWActionsStackView;

@protocol DWActionsStackViewDelegate <NSObject>

- (void)actionsStackViewDidUpdateLayout:(DWActionsStackView *)view;
- (void)actionsStackView:(DWActionsStackView *)view didAction:(DWAlertAction *)action;
- (void)actionsStackView:(DWActionsStackView *)view highlightActionAtRect:(CGRect)rect;

@end

/**
 Stack view of DWAlertController's actions
 */
@interface DWActionsStackView : UIStackView

@property (readonly, copy, nonatomic) NSArray<DWAlertViewActionBaseView *> *arrangedSubviews;
@property (nullable, weak, nonatomic) id<DWActionsStackViewDelegate> delegate;
@property (nullable, strong, nonatomic) DWAlertAction *preferredAction;

- (void)addActionButton:(DWAlertViewActionBaseView *)button;
- (void)resetActionsState;
- (void)removeAllActions;

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithArrangedSubviews:(NSArray<__kindof UIView *> *)views NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
