//
//  TextFieldViewController.swift
//  DWAlertController_Example
//
//  Created by Andrew Podkovyrin on 9/1/19.
//  Copyright © 2019 Dash Core Group. All rights reserved.
//

import UIKit
import DWAlertController

protocol TextFieldViewControllerDelegate: AnyObject {
    func textFieldViewControllerDidCancel(_ controller: TextFieldViewController)
    func textFieldViewController(_ controller: TextFieldViewController, didInputText text: String?)
}

/// Controller with title label and text field.
/// For simplicity sake, as a title used  `title` property of the UIViewController.
class TextFieldViewController: UIViewController {
    class func controller() -> TextFieldViewController {
        let storyboard = UIStoryboard(name: "TextField", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? TextFieldViewController else {
            fatalError()
        }
        
        return controller
    }
    
    weak var delegate: TextFieldViewControllerDelegate?
    
    lazy var providedActions: [DWAlertAction] = {
        let cancelAction = DWAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel,
                                         handler: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.textFieldViewControllerDidCancel(self)
        })
        
        let nextAction = DWAlertAction(title: NSLocalizedString("Next", comment: ""),
                                       style: .default,
                                       handler: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.textFieldViewController(self, didInputText: self.textField.text)
        })
        
        return [cancelAction, nextAction]
    }()
    
    var preferredAction: DWAlertAction {
        return providedActions.last!
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _ = textField.resignFirstResponder()
    }
}

extension TextFieldViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldViewController(self, didInputText: textField.text)
        return true
    }
}
