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

#import "DWAlertDismissalAnimationController.h"

#import "DWAlertInternalConstants.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DWAlertDismissalAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController =
        [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController =
        [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
        delay:0.0
        usingSpringWithDamping:DWAlertTransitionAnimationDampingRatio
        initialSpringVelocity:DWAlertTransitionAnimationInitialVelocity
        options:DWAlertTransitionAnimationOptions
        animations:^{
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            fromViewController.view.alpha = 0.0;
        }
        completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return DWAlertTransitionAnimationDuration;
}

@end

NS_ASSUME_NONNULL_END
