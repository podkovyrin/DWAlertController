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

#import "DWActionsStackView.h"

#import "DWAlertInternalConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface DWActionsStackView () <DWAlertViewActionBaseViewDelegate>

@property (nullable, strong, nonatomic) DWAlertViewActionBaseView *cancelButton;
@property (null_resettable, strong, nonatomic) id /* UISelectionFeedbackGenerator */ feedbackGenerator;
@property (nullable, strong, nonatomic) DWAlertViewActionBaseView *highlightedButton;

@end

@implementation DWActionsStackView

@dynamic arrangedSubviews;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.axis = UILayoutConstraintAxisHorizontal;
        self.alignment = UIStackViewAlignmentFill;
        self.distribution = UIStackViewDistributionFillEqually;
        self.spacing = DWAlertViewSeparatorSize();

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentSizeCategoryDidChangeNotification:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)addActionButton:(DWAlertViewActionBaseView *)button {
    NSAssert([button isKindOfClass:DWAlertViewActionBaseView.class], @"Invalid button type");

    button.delegate = self;
    if (button.alertAction.style == DWAlertActionStyleCancel) {
        self.cancelButton = button;
    }
    [self addArrangedSubview:button];

    [self updatePreferredAction];
    [self updateButtonsLayout];
}

- (void)resetActionsState {
    [self resetHighlightedButton];
}

- (void)setPreferredAction:(nullable DWAlertAction *)preferredAction {
    _preferredAction = preferredAction;
    [self updatePreferredAction];
}

- (void)removeAllActions {
    [self resetHighlightedButton];

    NSArray<DWAlertViewActionBaseView *> *actions = [self.arrangedSubviews copy];
    for (DWAlertViewActionBaseView *button in actions) {
        button.delegate = nil;
        [self removeArrangedSubview:button];
        [button removeFromSuperview];
    }

    _preferredAction = nil;
    self.cancelButton = nil;
}

#pragma mark - DWAlertViewActionButtonDelegate

- (void)actionView:(DWAlertViewActionBaseView *)actionButton touchBegan:(UITouch *)touch {
    if (actionButton.alertAction.enabled) {
        [self.delegate actionsStackView:self highlightActionAtRect:actionButton.frame];
        self.highlightedButton = actionButton;
    }

    [self.feedbackGenerator prepare];
}

- (void)actionView:(DWAlertViewActionBaseView *)actionButton touchMoved:(UITouch *)touch {
    CGRect highlightedRect = CGRectZero;
    DWAlertViewActionBaseView *highlightedButton = nil;
    for (DWAlertViewActionBaseView *button in self.arrangedSubviews) {
        const CGRect bounds = button.bounds;
        const CGPoint point = [touch locationInView:button];
        if (button.alertAction.enabled && CGRectContainsPoint(bounds, point)) {
            highlightedRect = button.frame;
            highlightedButton = button;
        }
    }
    [self.delegate actionsStackView:self highlightActionAtRect:highlightedRect];
    if (!!highlightedButton && highlightedButton != self.highlightedButton) {
        [self.feedbackGenerator selectionChanged];
        [self.feedbackGenerator prepare];
    }
    self.highlightedButton = highlightedButton;
}

- (void)actionView:(DWAlertViewActionBaseView *)actionButton touchEnded:(UITouch *)touch {
    for (DWAlertViewActionBaseView *button in self.arrangedSubviews) {
        const CGRect bounds = button.bounds;
        const CGPoint point = [touch locationInView:button];
        if (button.alertAction.enabled && CGRectContainsPoint(bounds, point)) {
            [self.delegate actionsStackView:self didAction:button.alertAction];
        }
    }
    [self resetHighlightedButton];
}

- (void)actionView:(DWAlertViewActionBaseView *)actionButton touchCancelled:(UITouch *)touch {
    [self resetHighlightedButton];
}

#pragma mark - Private

- (id)feedbackGenerator {
    if (@available(iOS 10.0, *)) {
        if (!_feedbackGenerator) {
            _feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
        }
        return _feedbackGenerator;
    }
    else {
        return nil;
    }
}

- (void)resetHighlightedButton {
    [self.delegate actionsStackView:self highlightActionAtRect:CGRectZero];
    self.feedbackGenerator = nil;
    self.highlightedButton = nil;
}

- (void)updatePreferredAction {
    if (!self.preferredAction) {
        self.cancelButton.preferred = YES;

        return;
    }

    for (DWAlertViewActionBaseView *button in self.arrangedSubviews) {
        button.preferred = (button.alertAction == self.preferredAction);
    }
}

- (void)updateButtonsLayout {
    NSArray<DWAlertViewActionBaseView *> *buttons = self.arrangedSubviews;
    const NSUInteger buttonsCount = buttons.count;
    if (buttonsCount < 2) {
        self.axis = UILayoutConstraintAxisHorizontal;
    }
    else if (buttonsCount == 2) {
        BOOL shouldBeVertical = NO;
        // only 2 horizontal buttons are allowed
        const CGFloat actionWidth = DWAlertViewWidth / 2.0 - DWAlertViewSeparatorSize();
        for (UIView *button in buttons) {
            const CGSize size = [button systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            if (size.width > actionWidth) {
                shouldBeVertical = YES;
                break;
            }
        }

        self.axis = shouldBeVertical ? UILayoutConstraintAxisVertical : UILayoutConstraintAxisHorizontal;
    }
    else {
        self.axis = UILayoutConstraintAxisVertical;
    }

    DWAlertViewActionBaseView *cancelButton = self.cancelButton;
    if (cancelButton && buttons.count > 1) {
        if (self.axis == UILayoutConstraintAxisHorizontal) {
            // Cancel always on the left
            if (buttons.firstObject != cancelButton) {
                [self removeArrangedSubview:cancelButton];
                [cancelButton removeFromSuperview];
                [self insertArrangedSubview:cancelButton atIndex:0];
            }
        }
        else {
            // Cancel always last
            if (buttons.lastObject != cancelButton) {
                [self removeArrangedSubview:cancelButton];
                [cancelButton removeFromSuperview];
                [self addArrangedSubview:cancelButton];
            }
        }
    }

    [self.delegate actionsStackViewDidUpdateLayout:self];
}

- (void)contentSizeCategoryDidChangeNotification:(NSNotification *)notification {
    for (DWAlertViewActionBaseView *button in self.arrangedSubviews) {
        [button updateForCurrentContentSizeCategory];
    }

    [self updateButtonsLayout];
}

@end

NS_ASSUME_NONNULL_END
