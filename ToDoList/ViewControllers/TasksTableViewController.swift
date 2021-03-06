//
//  TasksTableViewController.swift
//  ToDoList
//
//  Created by Beka Gelashvili on 5/27/20.
//  Copyright © 2020 Cornerstone Technologies. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)

    private var taskViewModels = TaskViewModel.all() ?? [TaskViewModel]()
    private var taskViewModelsGrouped: [Int: [TaskViewModel]] {
        return [
            0: taskViewModels.filter { $0.completedState == 0 },
            1: taskViewModels.filter { $0.completedState == 1 },
            2: taskViewModels.filter { $0.completedState == 2 }
        ]
    }
    private var filteredTaskViewModelsGrouped = [Int: [TaskViewModel]]()
    private var visibleTaskViewModelsGrouped: [Int: [TaskViewModel]] {
        if isFiltering {
            return filteredTaskViewModelsGrouped
        }
        return taskViewModelsGrouped
    }
    private var searchBarisEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarisEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TaskTableViewCell.nib, forCellReuseIdentifier: TaskTableViewCell.description)
        tableView.register(TasksTableViewHeaderView.nib, forHeaderFooterViewReuseIdentifier: TasksTableViewHeaderView.description)
        setSearchController()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return visibleTaskViewModelsGrouped.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleTaskViewModelsGrouped[section]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.description, for: indexPath) as! TaskTableViewCell
        let taskViewModel = visibleTaskViewModelsGrouped[indexPath.section]?[indexPath.row]
        cell.taskContentLabel.text = taskViewModel?.content
        cell.taskDateLabel.text = taskViewModel?.date?.toString(format: "yyyy-MM-dd HH:mm")
        return cell
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

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if visibleTaskViewModelsGrouped[section]?.isEmpty == true {
            return .zero
        }
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction1 = UIContextualAction(style: .normal, title: "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            Util.confirm(UIViewController: self, title: Variable.deleteTaskTitle, message: Variable.deleteTaskMessage) {
                let taskViewModel = self.visibleTaskViewModelsGrouped[indexPath.section]?[indexPath.row]
                taskViewModel?.delete(success: {
                    self.taskViewModels.removeAll { $0.id == taskViewModel?.id }
                    tableView.reloadData()
                })
            }
            success(true)
        })
        modifyAction1.image = Image.trash
        modifyAction1.backgroundColor = .white
        var actions = [modifyAction1]
        if indexPath.section == 0 {
            let modifyAction2 = UIContextualAction(style: .normal, title: "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                Util.confirm(UIViewController: self, title: Variable.startTaskTitle, message: Variable.startTaskMessage) {
                    let taskViewModel = self.visibleTaskViewModelsGrouped[indexPath.section]?[indexPath.row]
                    taskViewModel?.completedState = 1
                    taskViewModel?.update(success: {
                        tableView.reloadData()
                    }, failure: {
                            taskViewModel?.completedState = 0
                        })
                }
                success(true)
            })
            modifyAction2.backgroundColor = .white
            modifyAction2.image = Image.progress
            actions.append(modifyAction2)
        } else if indexPath.section == 1 {
            let modifyAction3 = UIContextualAction(style: .normal, title: "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                Util.confirm(UIViewController: self, title: Variable.finishTaskTitle, message: Variable.finishTaskMessage) {
                    let taskViewModel = self.visibleTaskViewModelsGrouped[indexPath.section]?[indexPath.row]
                    taskViewModel?.completedState = 2
                    taskViewModel?.update(success: {
                        tableView.reloadData()
                    }, failure: {
                            taskViewModel?.completedState = 1
                        })
                }
                success(true)
            })
            modifyAction3.backgroundColor = .white
            modifyAction3.image = Image.done
            actions.append(modifyAction3)
        }
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    @IBAction func onAddTaskBarButtonItemTapped() {
        Util.prompt(UIViewController: self, title: Variable.addTaskTitle, message: Variable.addTaskMessage, initialValue: "") { value in
            let taskViewModel = TaskViewModel(content: value)
            taskViewModel.create(success: { taskViewModel in
                if let taskViewModel = taskViewModel {
                    self.taskViewModels.insert(taskViewModel, at: 0)
                    self.tableView.reloadData()
                    self.tableView.scrollToTop()
                }
            })
        }
    }

    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func filterContentForSearchText(_ searchText: String) {
        resetFilter()
        filteredTaskViewModelsGrouped = taskViewModelsGrouped.mapValues { element in
            element.filter { (task) -> Bool in
                return task.content?.contains(searchText) ?? false
            }
        }
//        print("DEBUG \(filteredTaskViewModelsGrouped.count)")
//        print("DEBUG \(filteredTaskViewModelsGrouped)")
        tableView.reloadData()
    }

    private func resetFilter() {
        filteredTaskViewModelsGrouped.removeAll()
    }

}

extension TasksTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        filterContentForSearchText(text)
    }

}
