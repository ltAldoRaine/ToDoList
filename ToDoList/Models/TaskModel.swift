//
//  TaskModel.swift
//  ToDoList
//
//  Created by Beka Gelashvili on 5/28/20.
//  Copyright © 2020 Cornerstone Technologies. All rights reserved.
//

import CoreStore

class TaskModel {

    var id: String?
    var content: String?
    var date: Date?
    var priority: Int16?
    var completedState: Int16

    init(id: String? = nil, content: String?, date: Date? = nil, priority: Int16? = nil, completedState: Int16 = 0) {
        self.id = id
        self.content = content
        self.date = date
        self.priority = priority
        self.completedState = completedState
    }

    init(taskEntity: TaskEntity) {
        self.id = taskEntity.id
        self.content = taskEntity.content
        self.date = taskEntity.date
        self.priority = taskEntity.priority
        self.completedState = taskEntity.completedState
    }

    static func all() -> [TaskModel]? {
        do {
            return try UIApplication.appDelegate.dataStack.fetchAll(From<TaskEntity>()).map { TaskModel(taskEntity: $0) }
        }
        catch {
            print(error)
        }
        return nil
    }

    func create(success: ((_ taskViewModel: TaskViewModel?) -> Void)? = nil, failure: (() -> Void)? = nil) {
        do {
            let maxPriority = try UIApplication.appDelegate.dataStack.queryValue(
                From<TaskEntity>(),
                Select<TaskEntity, Int16>(.maximum("priority"))
            ) ?? 0
            var taskEntity: TaskEntity?
            UIApplication.appDelegate.dataStack.perform(
                asynchronous: { (transaction) -> Void in
                    taskEntity = transaction.create(Into<TaskEntity>())
                    taskEntity?.id = UUID().uuidString
                    taskEntity?.content = self.content
                    taskEntity?.date = Date()
                    taskEntity?.priority = maxPriority + 1
                    taskEntity?.completedState = self.completedState
                },
                completion: { (result) -> Void in
                    switch result {
                    case .success:
                        if let taskEntity = taskEntity {
                            success?(TaskViewModel(taskModel: TaskModel(taskEntity: taskEntity)))
                        }
                    case .failure (let error):
                        failure?()
                        print(error)
                    }
                }
            )
        }
        catch {
            print(error)
        }
    }

    func update(success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
        UIApplication.appDelegate.dataStack.perform(
            asynchronous: { (transaction) -> Void in
                let taskEntity = try transaction.fetchOne(
                    From<TaskEntity>()
                        .where(\.id == self.id)
                )
                if let priority = self.priority {
                    taskEntity?.priority = priority
                }
                taskEntity?.completedState = self.completedState
            },
            completion: { (result) -> Void in
                switch result {
                case .success:
                    success?()
                case .failure (let error):
                    failure?()
                    print(error)
                }
            }
        )
    }

    func delete(success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
        UIApplication.appDelegate.dataStack.perform(
            asynchronous: { (transaction) -> Void in
                try transaction.deleteAll(
                    From<TaskEntity>()
                        .where(\.id == self.id)
                )
            },
            completion: { (result) -> Void in
                switch result {
                case .success:
                    success?()
                case .failure (let error):
                    failure?()
                    print(error)
                }
            }
        )
    }

}
