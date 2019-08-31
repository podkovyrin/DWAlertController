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

import UIKit

// The `backgroundColor` of the content controller's view should be transparent (`UIColor.clear`).
// RichViewController view's backgroundColor is set in the Storyboard.

class RichViewController: UIViewController {
    class func controller() -> RichViewController {
        let storyboard = UIStoryboard(name: "Rich", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? RichViewController else {
            fatalError()
        }
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            textLabel.adjustsFontForContentSizeCategory = true
        }
        else {
            // not implemented in the Example app
        }
    }
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBAction private func switchControlAction(_ sender: UISwitch) {
        textLabel.text = sender.isOn ? "It works!" : "Turn me on!"
    }
}
