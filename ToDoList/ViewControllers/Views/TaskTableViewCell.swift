//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Beka Gelashvili on 5/27/20.
//  Copyright © 2020 Cornerstone Technologies. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskContentLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!

    static let description = "TaskTableViewCell"
    static let nib = UINib(nibName: description, bundle: nil)

    override func prepareForReuse() {
        super.prepareForReuse()
        taskContentLabel.text = nil
        taskDateLabel.text = nil
    }

}
