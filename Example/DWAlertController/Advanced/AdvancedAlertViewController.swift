//
//  AdvancedAlertViewController.swift
//  DWAlertController_Example
//
//  Created by Andrew Podkovyrin on 9/1/19.
//  Copyright © 2019 Dash Core Group. All rights reserved.
//

import UIKit
import DWAlertController

/// Example of advanced usage of DWAlertController.
/// AdvancedViewController is inherited from DWAlertController and switches between their child controllers within itself.
/// Each child controller comes with their own `providedActions` and optional `preferredAction`.
class AdvancedAlertViewController: DWAlertController {
    struct Profile {
        var name: String?
        var surname: String? = "sir"
    }
    
    init() {
        nameController = TextFieldViewController.controller()
        nameController.title = NSLocalizedString("Enter your name", comment: "")
        
        super.init(contentController: nameController)
        
        nameController.delegate = self
        setupActions(nameController.providedActions)
        preferredAction = nameController.preferredAction
    }

    private var profile = Profile()
    
    private let nameController: TextFieldViewController
    
    private lazy var surnameController: TextFieldViewController = {
        let controller = TextFieldViewController.controller()
        controller.title = NSLocalizedString("Enter your surname", comment: "")
        controller.delegate = self
        
        return controller
    }()
    
    private lazy var formResult: FormResultViewController = {
        let controller = FormResultViewController.controller()
        let name = self.profile.name  ?? "?"
        let surname = self.profile.surname ?? "?"
        controller.title = "Hello 👋,\n\(name) \(surname)!"
        controller.delegate = self
        
        return controller
    }()
}

extension AdvancedAlertViewController: TextFieldViewControllerDelegate {
    func textFieldViewControllerDidCancel(_ controller: TextFieldViewController) {
        if controller === nameController {
            dismiss(animated: true)
        }
        else {
            performTransition(toContentController: nameController, animated: true)
            setupActions(nameController.providedActions)
            preferredAction = nameController.preferredAction
        }
    }
    
    func textFieldViewController(_ controller: TextFieldViewController, didInputText text: String?) {
        if controller === nameController {
            profile.name = text

            performTransition(toContentController: surnameController, animated: true)
            setupActions(surnameController.providedActions)
            preferredAction = surnameController.preferredAction
        }
        else {
            profile.surname = text
            
            performTransition(toContentController: formResult, animated: true)
            setupActions(formResult.providedActions)
        }
    }
}

extension AdvancedAlertViewController: FormResultViewControllerDelegate {
    func formResultViewControllerDidFinish(_ controller: FormResultViewController) {
        dismiss(animated: true)
    }
}
