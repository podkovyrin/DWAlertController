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

class PasscodeViewController: UIViewController {
    private static let pin = "1234"
    
    private let pinField = NumericPinField()
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        if #available(iOS 10.0, *) {
            titleLabel.adjustsFontForContentSizeCategory = true
        }
        titleLabel.numberOfLines = 0
        if #available(iOS 13.0, *) {
            titleLabel.textColor = .label
        } else {
            titleLabel.textColor = .black
        }
        titleLabel.text = NSLocalizedString("Enter passcode", comment: "")
        
        pinField.translatesAutoresizingMaskIntoConstraints = false
        pinField.delegate = self
        
        let spacing: CGFloat = 16
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, pinField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = spacing
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        
        if #available(iOS 10.0, *) {
            // NOP
        }
        else {
            let nc = NotificationCenter.default
            nc.addObserver(self,
                           selector: #selector(contentSizeCategoryDidChangeNotification),
                           name: UIContentSizeCategory.didChangeNotification,
                           object: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _ = pinField.becomeFirstResponder()
    }
    
    @objc
    private func contentSizeCategoryDidChangeNotification() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    }
}

extension PasscodeViewController: NumericPinFieldDelegate {
    func numericPinFieldDidFinishInput(_ pinField: NumericPinField) {
        if pinField.text == PasscodeViewController.pin {
            assert(presentingViewController != nil)
            dismiss(animated: true)
        }
        else {
            pinField.clear()
            pinField.shake()
        }
    }
}
