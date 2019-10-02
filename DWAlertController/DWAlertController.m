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

#import "DWAlertController.h"

#import "Private/DWAlertAction+DWProtected.h"
#import "Private/DWAlertController+DWKeyboard.h"
#import "Private/DWAlertDismissalAnimationController.h"
#import "Private/DWAlertInternalConstants.h"
#import "Private/DWAlertPresentationAnimationController.h"
#import "Private/DWAlertPresentationController.h"
#import "Private/DWAlertView.h"
#import "Private/DWAlertViewActionBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DWAlertController () <UIViewControllerTransitioningDelegate, DWAlertViewDelegate>

@property (null_resettable, strong, nonatomic) DWAlertView *alertView;
@property (strong, nonatomic) NSLayoutConstraint *alertViewCenterYConstraint;
@property (strong, nonatomic) NSLayoutConstraint *alertViewHeightConstraint;

@property (nullable, strong, nonatomic) __kindof UIViewController *contentController;
@property (copy, nonatomic) NSArray<DWAlertAction *> *actions;

@property (nullable, nonatomic, weak) DWAlertPresentationController *alertPresentationController;

// hides warning
+ (instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... __attribute__((deprecated));
+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait
                             whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... __attribute__((deprecated));

- (instancetype)init NS_UNAVAILABLE;

@end

@implementation DWAlertController

+ (instancetype)alertControllerWithContentController:(__kindof UIViewController *)contentController {
    return [[self alloc] initWithContentController:contentController];
}

- (instancetype)initWithContentController:(__kindof UIViewController *)contentController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _contentController = contentController;

        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        self.actions = @[];

        [self displayViewController:contentController];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class DWAlertController. Use -initWithContentController: instead."
                                 userInfo:nil];
    return nil;
}

- (DWAlertView *)alertView {
    if (!_alertView) {
        DWAlertView *alertView = [[DWAlertView alloc] initWithFrame:self.view.bounds];
        alertView.translatesAutoresizingMaskIntoConstraints = NO;
        alertView.delegate = self;
        [self.view addSubview:alertView];

        CGFloat maximumAllowedViewHeight = [self maximumAllowedAlertHeightWithKeyboard:0.0];
        [NSLayoutConstraint activateConstraints:@[
            [alertView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            (self.alertViewCenterYConstraint = [alertView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]),
            [alertView.widthAnchor constraintEqualToConstant:DWAlertViewWidth],
            (self.alertViewHeightConstraint = [alertView.heightAnchor constraintLessThanOrEqualToConstant:maximumAllowedViewHeight]),
        ]];
        _alertView = alertView;
    }
    return _alertView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSAssert(self.contentController, @"Alert must be configured with a content controller");

    [self dw_startObservingKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self dw_stopObservingKeyboardNotifications];
    [self.view endEditing:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self updateDimmedViewVisiblePath];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator
        animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            const CGFloat maximumAllowedViewHeight =
                [self maximumAllowedAlertHeightWithKeyboard:self.dw_keyboardHeight];

            self.alertViewHeightConstraint.constant = maximumAllowedViewHeight;
            [self.alertView setNeedsLayout];
            [self.alertView layoutIfNeeded];
            [self.alertView resetActionsState];
        }
                        completion:nil];
}

#pragma mark - Public

- (void)performTransitionToContentController:(UIViewController *)controller animated:(BOOL)animated {
    NSParameterAssert(controller);
    NSAssert(self.contentController, @"Content view controller should exist");

    [self performTransitionFromViewController:self.contentController
                             toViewController:controller
                                     animated:animated];
    self.contentController = controller;
}

- (void)addAction:(DWAlertAction *)action {
    NSParameterAssert(action);

#ifdef DEBUG
    if (action.style == DWAlertActionStyleCancel) {
        for (DWAlertAction *a in self.actions) {
            if (a.style == DWAlertActionStyleCancel) {
                NSAssert(NO, @"DWAlertController can only have one action with a style of DWAlertActionStyleCancel");
            }
        }
    }
#endif

    NSMutableArray *mutableActions = [self.actions mutableCopy];
    [mutableActions addObject:action];
    self.actions = mutableActions;

    [self.alertView addAction:action];

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)setupActions:(NSArray<DWAlertAction *> *)actions {
    NSParameterAssert(actions);

#ifdef DEBUG
    BOOL hasCancelAction = NO;
    for (DWAlertAction *a in actions) {
        if (hasCancelAction && a.style == DWAlertActionStyleCancel) {
            NSAssert(NO, @"DWAlertController can only have one action with a style of DWAlertActionStyleCancel");
        }
        hasCancelAction = a.style == DWAlertActionStyleCancel;
    }
#endif

    [self.alertView removeAllActions];

    self.actions = actions;

    for (DWAlertAction *action in actions) {
        [self.alertView addAction:action];
    }

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (nullable DWAlertAction *)preferredAction {
    return self.alertView.preferredAction;
}

- (void)setPreferredAction:(nullable DWAlertAction *)preferredAction {
    NSAssert([self.actions indexOfObject:preferredAction] != NSNotFound, @"The action object you assign to this property must have already been added to the alert controller’s list of actions.");
    self.alertView.preferredAction = preferredAction;
}

- (DWAlertAppearanceMode)appearanceMode {
    return self.alertView.appearanceMode;
}

- (void)setAppearanceMode:(DWAlertAppearanceMode)appearanceMode {
    self.alertView.appearanceMode = appearanceMode;
    self.alertPresentationController.appearanceMode = appearanceMode;
}

- (void)setNormalTintColor:(UIColor *)normalTintColor {
    _normalTintColor = normalTintColor;
    self.alertView.normalTintColor = normalTintColor;
}

- (void)setDisabledTintColor:(UIColor *)disabledTintColor {
    _disabledTintColor = disabledTintColor;
    self.alertView.disabledTintColor = disabledTintColor;
}

- (void)setDestructiveTintColor:(UIColor *)destructiveTintColor {
    _destructiveTintColor = destructiveTintColor;
    self.alertView.destructiveTintColor = destructiveTintColor;
}

#pragma mark - DWAlertViewDelegate

- (void)alertView:(DWAlertView *)alertView didAction:(DWAlertAction *)action {
    if (action.handler) {
        action.handler(action);
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                           presentingController:(UIViewController *)presenting
                                                                               sourceController:(UIViewController *)source {
    DWAlertPresentationAnimationController *animationController = [[DWAlertPresentationAnimationController alloc] init];
    return animationController;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    DWAlertDismissalAnimationController *animationController = [[DWAlertDismissalAnimationController alloc] init];
    return animationController;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                               presentingViewController:(nullable UIViewController *)presenting
                                                                   sourceViewController:(UIViewController *)source {
    DWAlertPresentationController *presentationController = [[DWAlertPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    self.alertPresentationController = presentationController;
    return presentationController;
}

#pragma mark - Keyboard

- (void)dw_keyboardWillShowOrHideWithHeight:(CGFloat)height
                          animationDuration:(NSTimeInterval)animationDuration
                             animationCurve:(UIViewAnimationCurve)animationCurve {
    CGFloat maximumAllowedViewHeight = [self maximumAllowedAlertHeightWithKeyboard:height];
    self.alertViewHeightConstraint.constant = maximumAllowedViewHeight;
    self.alertViewCenterYConstraint.constant = -height / 2.0;
}

- (void)dw_keyboardShowOrHideAnimationWithHeight:(CGFloat)height
                               animationDuration:(NSTimeInterval)animationDuration
                                  animationCurve:(UIViewAnimationCurve)animationCurve {
    [self.alertView setNeedsLayout];
    [self.alertView layoutIfNeeded];
    [self.view layoutIfNeeded];
}

#pragma mark - UIAppearance

// Use DWAlertView as appearance proxy

+ (instancetype)appearance {
    return (DWAlertController *)[DWAlertView appearance];
}

+ (instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
    NSAssert(NO, @"Method is deprecated");
    return nil;
}

+ (instancetype)appearanceWhenContainedInInstancesOfClasses:(NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    return (DWAlertController *)[DWAlertView appearanceWhenContainedInInstancesOfClasses:containerTypes];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait {
    return (DWAlertController *)[DWAlertView appearanceForTraitCollection:trait];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait
                             whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
    NSAssert(NO, @"Method is deprecated");
    return nil;
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait
           whenContainedInInstancesOfClasses:(NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    return (DWAlertController *)[DWAlertView appearanceForTraitCollection:trait
                                        whenContainedInInstancesOfClasses:containerTypes];
}

#pragma mark - Private

- (void)updateDimmedViewVisiblePath {
    DWAlertPresentationController *presentationController = (DWAlertPresentationController *)self.presentationController;
    if ([presentationController isKindOfClass:DWAlertPresentationController.class]) {
        CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
        CGFloat alertHeight = CGRectGetHeight(self.alertView.frame);
        CGFloat centeredAlertY = (viewHeight - alertHeight) / 2.0;
        CGFloat alertY = centeredAlertY + self.alertViewCenterYConstraint.constant;

        CGRect rect = CGRectMake(CGRectGetMinX(self.alertView.frame),
                                 alertY,
                                 CGRectGetWidth(self.alertView.frame),
                                 alertHeight);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:DWAlertViewCornerRadius];
        presentationController.dimmingView.visiblePath = path;
    }
}

- (void)displayViewController:(UIViewController *)controller {
    NSParameterAssert(controller);

    [self addChildViewController:controller];

    UIView *childView = controller.view;
    [self.alertView setupChildView:childView];

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

    [controller didMoveToParentViewController:self];
}

- (void)performTransitionFromViewController:(UIViewController *)fromViewController
                           toViewController:(UIViewController *)toViewController
                                   animated:(BOOL)animated {
    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;

    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];

    [self.alertView setupChildView:toView];

    toView.alpha = 0.0;

    [UIView animateWithDuration:animated ? DWAlertInplaceTransitionAnimationDuration : 0.0
        delay:0.0
        usingSpringWithDamping:DWAlertInplaceTransitionAnimationDampingRatio
        initialSpringVelocity:DWAlertInplaceTransitionAnimationInitialVelocity
        options:DWAlertInplaceTransitionAnimationOptions
        animations:^{
            toView.alpha = 1.0;
            fromView.alpha = 0.0;
        }
        completion:^(BOOL finished) {
            [fromView removeFromSuperview];
            [fromViewController removeFromParentViewController];
            [toViewController didMoveToParentViewController:self];
        }];
}

- (CGFloat)maximumAllowedAlertHeightWithKeyboard:(CGFloat)keyboardHeight {
    CGFloat minInset;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        minInset = MAX(insets.top, insets.bottom);
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        minInset = MAX(self.topLayoutGuide.length, self.bottomLayoutGuide.length);
#pragma clang diagnostic pop
    }

    CGFloat padding = DWAlertViewVerticalPadding(minInset, keyboardHeight > 0.0);
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds) - padding * 2.0 - keyboardHeight;

    return height;
}

@end

NS_ASSUME_NONNULL_END
