//
//  DateExtension.swift
//  ToDoList
//
//  Created by Beka Gelashvili on 5/28/20.
//  Copyright © 2020 Cornerstone Technologies. All rights reserved.
//

import Foundation

extension Date {

    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}

