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

#import "../DWAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@class DWAlertViewActionBaseView;

@protocol DWAlertViewActionBaseViewDelegate <NSObject>

- (void)actionView:(DWAlertViewActionBaseView *)actionView touchBegan:(UITouch *)touch;
- (void)actionView:(DWAlertViewActionBaseView *)actionView touchMoved:(UITouch *)touch;
- (void)actionView:(DWAlertViewActionBaseView *)actionView touchEnded:(UITouch *)touch;
- (void)actionView:(DWAlertViewActionBaseView *)actionView touchCancelled:(UITouch *)touch;

@end

/**
 Base class for action views for handling touches.
 */
@interface DWAlertViewActionBaseView : UIView

@property (readonly, strong, nonatomic) DWAlertAction *alertAction;
@property (assign, nonatomic, getter=isPreferred) BOOL preferred;
@property (nullable, weak, nonatomic) id<DWAlertViewActionBaseViewDelegate> delegate;

@property (strong, nonatomic) UIColor *normalTintColor;
@property (strong, nonatomic) UIColor *disabledTintColor;
@property (strong, nonatomic) UIColor *destructiveTintColor;

- (instancetype)initWithAlertAction:(DWAlertAction *)alertAction NS_DESIGNATED_INITIALIZER;

- (void)updateForCurrentContentSizeCategory;
- (void)updateEnabledState NS_REQUIRES_SUPER;

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
