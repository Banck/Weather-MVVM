//
//  UIViewControllerExtension.swift
//  Weather MVVM example
//
//  Created by Сахабаев Егор on 28.03.17.
//  Copyright © 2017 Сахабаев Егор. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    
    func showAlert(title: String? = nil, message: String?, cancel: String? = nil, buttons: [String]? = nil, textField:  Bool = false, completion: ((UIAlertController, UIAlertAction) -> Void)? = nil) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var cancelTitle: String = NSLocalizedString("Done", comment:"")
        if cancel != nil {
            cancelTitle = cancel!
        }
        let action: UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (alertAction) in
            if completion != nil {
                completion!(alert, alertAction)
            }
        })
        alert.addAction(action)
        
        if textField {
            alert.addTextField(configurationHandler: nil)
        }

        if buttons != nil {
            for buttonTitle in buttons! {
                let action: UIAlertAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (alertAction) in
                    if completion != nil {
                        completion!(alert, alertAction)
                    }
                })
                alert.addAction(action)
            }
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func topController() -> UIViewController?
    {
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController
        {
            presentedVC = pVC
        }
        return presentedVC
    }

}
