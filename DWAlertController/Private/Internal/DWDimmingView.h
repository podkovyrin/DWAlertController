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

NS_ASSUME_NONNULL_BEGIN

@interface DWDimmingView : UIView

/**
 Visible part of the dimming view (a hole)
 */
@property (nullable, strong, nonatomic) UIBezierPath *visiblePath;

/**
 Dimmed part of the view (entire view by default)
 */
@property (null_resettable, strong, nonatomic) UIBezierPath *dimmedPath;

/**
 Defaults to 1.0
 */
@property (assign, nonatomic) float dimmingOpacity;

/**
 [UIColor blackColor] by default
 */
@property (strong, nonatomic) UIColor *dimmingColor;

/**
 Inverts visible and dimmed paths
 */
@property (assign, nonatomic) BOOL inverted;

/**
 Disable `path` animations of underlying layer
 */
- (void)setPathAnimationsDisabled;

@end

NS_ASSUME_NONNULL_END
