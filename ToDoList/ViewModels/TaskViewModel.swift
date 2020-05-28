//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Beka Gelashvili on 5/28/20.
//  Copyright © 2020 Cornerstone Technologies. All rights reserved.
//

import Foundation

class TaskViewModel {

    private let taskModel: TaskModel

    var id: String?
    var content: String?
    var date: Date?
    var priority: Int16?
    var completedState: Int16

    init(taskModel: TaskModel) {
        self.taskModel = taskModel
        id = taskModel.id
        content = taskModel.content
        date = taskModel.date
        priority = taskModel.priority
        completedState = taskModel.completedState
    }

    convenience init(content: String?) {
        self.init(taskModel: TaskModel(content: content))
    }

    static func all() -> [TaskViewModel]? {
        guard var all = TaskModel.all() else {
            return nil
        }
        //sorty by completed state
        all.sort { (taskModel1, taskModel2) -> Bool in
            taskModel1.completedState > taskModel2.completedState
        }
        //sorty by date
        all.sort { (taskModel1, taskModel2) -> Bool in
            if let date1 = taskModel1.date, let date2 = taskModel2.date {
                return date1 > date2
            }
            return false
        }
        return all.map { TaskViewModel(taskModel: $0) }
    }

    func create(success: ((_ taskViewModel: TaskViewModel?) -> Void)? = nil, failure: (() -> Void)? = nil) {
        let taskModel = TaskModel(content: content)
        taskModel.create(success: success, failure: failure)
    }

    func update(success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
        taskModel.priority = priority
        taskModel.completedState = completedState
        taskModel.update(success: success, failure: failure)
    }

    func delete(success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
        taskModel.delete(success: success, failure: failure)
    }

}
