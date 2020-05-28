//
//  TasksTableViewHeaderView.swift
//  ToDoList
//
//  Created by Beka Gelashvili on 5/27/20.
//  Copyright © 2020 Cornerstone Technologies. All rights reserved.
//

import UIKit

class TasksTableViewHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!

    static let description = "TasksTableViewHeaderView"
    static let nib = UINib(nibName: description, bundle: nil)

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

}
