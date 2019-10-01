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
import DWAlertController

// Important notice:
// To make DWAlertController works with a custom content controller, the view of the content controller must correctly implement Autolayout.
// You might have used the same technique when implementing dynamic-sized UITableViewCell's.
// See https://stackoverflow.com/a/18746930

class CatalogViewController: UITableViewController {
    enum AlertIndex: Int {
        case native = 0
        case titleMessage = 1
        case rich = 2
        case passcode = 3
        case longText = 4
        case advanced = 5
        case tinted = 6
        case alwaysLight = 7
        case alwaysDark = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dummy button to check `tintAdjustmentMode`
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dummy Button",
                                                            style: .plain,
                                                            target: nil,
                                                            action: nil)
    }
        
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = AlertIndex(rawValue: indexPath.row)!
        switch index {
        case .native:
            showNativeAlert()
        case .titleMessage:
            showTitleMessageAlert()
        case .rich:
            showRichAlert()
        case .passcode:
            showPasscodeAlert()
        case .longText:
            showLongTextAlert()
        case .advanced:
            showAdvancedAlert()
        case .tinted:
            showTintedAlert()
        case .alwaysLight:
            showAlwaysLightAlert()
        case .alwaysDark:
            showAlwaysDarkAlert()
        }
    }
    
    // MARK: Private
    
    private let alertTitle = "Hey I'm an alert"
    private let alertMessage = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
    
    private func showNativeAlert() {
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                   style: .default,
                                   handler: nil)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                     style: .cancel,
                                     handler: nil)
        cancelAction.isEnabled = false
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showTitleMessageAlert() {
        let controller = TitleMessageViewController(title: alertTitle,
                                                    message: alertMessage)
        let alert = DWAlertController(contentController: controller)
        
        let okAction = DWAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        
        let cancelAction = DWAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel,
                                         handler: nil)
        cancelAction.isEnabled = false;
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showRichAlert() {
        let controller = RichViewController.controller()
        
        let alert = DWAlertController(contentController: controller)
        
        let okAction = DWAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .cancel,
                                     handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func showPasscodeAlert() {
        let controller = PasscodeViewController()
        
        let alert = DWAlertController(contentController: controller)
        
        let okAction = DWAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                     style: .cancel,
                                     handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func showLongTextAlert() {
        // Important notice:
        // Since DWAlertController maintain scrolling of large content controllers internally
        // (as UIAlertController does) there is no need in placing the content of content view controller
        // within UIScrollView.
        let controller = UIStoryboard(name: "LongText", bundle: nil).instantiateInitialViewController()!
        
        let alert = DWAlertController(contentController: controller)
        
        let okAction = DWAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .cancel,
                                     handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func showAdvancedAlert() {
        let alert = AdvancedAlertViewController()
        present(alert, animated: true)
    }
    
    private func showTintedAlert() {
        let controller = TitleMessageViewController(title: alertTitle,
                                                    message: alertMessage)
        
        let alert = DWAlertController(contentController: controller)
        alert.normalTintColor = .green
        alert.disabledTintColor = .lightGray
        alert.destructiveTintColor = .magenta
        
        let okAction = DWAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        
        let destructiveAction = DWAlertAction(title: NSLocalizedString("Delete", comment: ""),
                                     style: .destructive,
                                     handler: nil)
        alert.addAction(destructiveAction)

        let cancelAction = DWAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel,
                                         handler: nil)
        cancelAction.isEnabled = false;
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showAlwaysLightAlert() {
        let controller = TitleMessageViewController(title: alertTitle,
                                                    message: "Alert with always light appearance ☀️")
        if #available(iOS 13.0, *) {
            controller.overrideUserInterfaceStyle = .light
        }
        let alert = DWAlertController(contentController: controller)
        alert.appearanceMode = .light
        
        let okAction = DWAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        
        present(alert, animated: true)
    }
    
    private func showAlwaysDarkAlert() {
        let controller = TitleMessageViewController(title: alertTitle,
                                                    message: "Alert with always dark appearance 🌑")
        if #available(iOS 13.0, *) {
            controller.overrideUserInterfaceStyle = .dark
        }
        let alert = DWAlertController(contentController: controller)
        alert.appearanceMode = .dark
        
        let okAction = DWAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        
        present(alert, animated: true)
    }
}

