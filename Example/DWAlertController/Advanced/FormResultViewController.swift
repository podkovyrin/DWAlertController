//
//  FormResultViewController.swift
//  DWAlertController_Example
//
//  Created by Andrew Podkovyrin on 9/1/19.
//  Copyright © 2019 Dash Core Group. All rights reserved.
//

import UIKit
import DWAlertController

protocol FormResultViewControllerDelegate: AnyObject {
    func formResultViewControllerDidFinish(_ controller: FormResultViewController)
}

class FormResultViewController: UIViewController {
    class func controller() -> FormResultViewController {
        let storyboard = UIStoryboard(name: "FormResult", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? FormResultViewController else {
            fatalError()
        }
        
        return controller
    }
    
    weak var delegate: FormResultViewControllerDelegate?
    
    lazy var providedActions: [DWAlertAction] = {
        let doneAction = DWAlertAction(title: NSLocalizedString("Done", comment: ""),
                                       style: .cancel,
                                       handler: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.formResultViewControllerDidFinish(self)
        })
        
        return [doneAction]
    }()

    @IBOutlet private var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultLabel.text = title
    }
}
