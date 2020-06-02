//
//  StringExtension.swift
//  ToDoList
//
//  Created by Beka Gelashvili on 6/2/20.
//  Copyright © 2020 Cornerstone Technologies. All rights reserved.
//

extension String {

    mutating func trim() {
        self = trimmingCharacters(in: .whitespaces)
    }

}
