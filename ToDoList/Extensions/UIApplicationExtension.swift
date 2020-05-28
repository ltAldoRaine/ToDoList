//
//  UIApplicationExtension.swift
//  ToDoList
//
//  Created by Beka Gelashvili on 5/28/20.
//  Copyright © 2020 Cornerstone Technologies. All rights reserved.
//

import CoreStore

extension UIApplication {

    static var appDelegate: AppDelegate {
        return shared.delegate as! AppDelegate
    }
    static var dataStack: DataStack {
        return appDelegate.dataStack
    }

}
