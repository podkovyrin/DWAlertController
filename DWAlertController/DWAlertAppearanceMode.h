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

#ifndef DWAlertAppearanceMode_h
#define DWAlertAppearanceMode_h

typedef NS_ENUM (NSInteger, DWAlertAppearanceMode) {
    /// Follows Dark Mode setting on iOS 13, uses the light appearance mode on iOS 12 or lower
    DWAlertAppearanceModeAutomatic,
    /// The light appearance mode
    DWAlertAppearanceModeLight,
    /// The dark appearance mode
    DWAlertAppearanceModeDark,
};

#endif /* DWAlertAppearanceMode_h */
