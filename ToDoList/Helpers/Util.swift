//
//  Util.swift
//  ToDoList
//
//  Created by Beka Gelashvili on 5/28/20.
//  Copyright © 2020 Cornerstone Technologies. All rights reserved.
//

import UIKit

class Util {

    static func confirm(UIViewController: UIViewController, title: String, message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let noAction = UIAlertAction(title: Variable.no, style: .cancel)
            let yesAction = UIAlertAction(title: Variable.yes, style: .default) { _ in
                DispatchQueue.main.async {
                    completion?()
                }
            }
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            UIViewController.present(alertController, animated: true)
        }
    }

    static func prompt(UIViewController: UIViewController, title: String, message: String, initialValue: String, keyboardType: UIKeyboardType? = .default, keyboardDelegate: UITextFieldDelegate? = nil, completion: ((_ value: String) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.text = initialValue
                textField.keyboardType = keyboardType!
                textField.delegate = keyboardDelegate
            }
            let cancelAction = UIAlertAction(title: Variable.cancel, style: .cancel)
            let saveAction = UIAlertAction(title: Variable.save, style: .default) { _ in
                completion?(alertController.textFields?.first?.text ?? initialValue)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            UIViewController.present(alertController, animated: true)
        }
    }

}
