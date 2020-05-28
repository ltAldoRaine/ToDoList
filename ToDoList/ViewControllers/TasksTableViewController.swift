//
//  TasksTableViewController.swift
//  ToDoList
//
//  Created by Beka Gelashvili on 5/27/20.
//  Copyright © 2020 Cornerstone Technologies. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: Image.background)
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        tableView.register(TaskTableViewCell.nib, forCellReuseIdentifier: TaskTableViewCell.description)
        tableView.register(TasksTableViewHeaderView.nib, forHeaderFooterViewReuseIdentifier: TasksTableViewHeaderView.description)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.description, for: indexPath) as! TaskTableViewCell
        cell.taskContentLabel.text = "blabla"
        cell.taskDateLabel.text = "11/03/2019 22:00:00"
        return cell
    }

    @IBAction func onAddTaskBarButtonItemTapped() {
        Util.prompt(UIViewController: self, title: "Add new task", message: "Please enter task content↴", initialValue: "") { value in

        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TasksTableViewHeaderView.description) as! TasksTableViewHeaderView
        if section == 0 {
            headerView.titleLabel.text = Variable.todo
        } else if section == 1 {
            headerView.titleLabel.text = Variable.progress
        } else {
            headerView.titleLabel.text = Variable.done
        }
        return headerView
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
