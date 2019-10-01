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

/// An example of the content view controller that displays title and message
class TitleMessageViewController: UIViewController {
    init(title: String?, message: String?) {
        titleLabel.text = title
        messageLabel.text = message
        titleLabel.isHidden = title?.isEmpty ?? true
        messageLabel.isHidden = message?.isEmpty ?? true
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        if #available(iOS 10.0, *) {
            titleLabel.adjustsFontForContentSizeCategory = true
        }
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        if #available(iOS 13.0, *) {
            titleLabel.textColor = .label
        } else {
            titleLabel.textColor = .black
        }
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        if #available(iOS 10.0, *) {
            messageLabel.adjustsFontForContentSizeCategory = true
        }
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        if #available(iOS 13.0, *) {
            titleLabel.textColor = .label
        } else {
            messageLabel.textColor = .black
        }
        messageLabel.setContentCompressionResistancePriority(.defaultHigh - 1, for: .vertical)
        
        let spacing: CGFloat = 4
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
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
    
    @objc
    private func contentSizeCategoryDidChangeNotification() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        messageLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
}
