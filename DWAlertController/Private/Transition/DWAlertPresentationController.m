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

#import "DWAlertPresentationController.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DWAlertPresentationController

- (BOOL)shouldPresentInFullscreen {
    return NO;
}

- (BOOL)shouldRemovePresentersView {
    return NO;
}

- (void)presentationTransitionWillBegin {
    self.dimmingView = [[DWDimmingView alloc] initWithFrame:self.containerView.bounds];
    self.dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.dimmingView.alpha = 0.0;
    [self.containerView addSubview:self.dimmingView];

    id<UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator
        animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.dimmingView.alpha = 1.0;
        }
                        completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];

    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];

    id<UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator
        animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.dimmingView.alpha = 0.0;
        }
                        completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];

    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];

    UIView *presentedView = [self presentedView];
    presentedView.frame = [self frameOfPresentedViewInContainerView];
    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.dimmedPath = nil; // reset
}

@end

NS_ASSUME_NONNULL_END
