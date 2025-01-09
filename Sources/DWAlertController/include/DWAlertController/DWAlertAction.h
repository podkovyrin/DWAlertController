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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DWAlertActionStyle) {
    DWAlertActionStyleDefault = 0,
    DWAlertActionStyleCancel,
    DWAlertActionStyleDestructive,
} NS_SWIFT_NAME(DWAlertAction.Style);

@interface DWAlertAction : NSObject

@property (nullable, readonly, copy, nonatomic) NSString *title;
@property (readonly, assign, nonatomic) DWAlertActionStyle style;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          style:(DWAlertActionStyle)style
                        handler:(void (^__nullable)(DWAlertAction *action))handler;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
