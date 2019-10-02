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

#import "../DWAlertAppearanceMode.h"
#import "DWDimmingView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DWAlertPresentationController : UIPresentationController

/**
 Appearance mode of the dimming view
 */
@property (nonatomic, assign) DWAlertAppearanceMode appearanceMode;

@property (nullable, strong, nonatomic) DWDimmingView *dimmingView;

@end

NS_ASSUME_NONNULL_END
