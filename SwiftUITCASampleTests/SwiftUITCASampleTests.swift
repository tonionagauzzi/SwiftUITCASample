//
//  SwiftUITCASampleTests.swift
//  SwiftUITCASampleTests
//
//  Created by K Nagauchi on 2021/06/11.
//

import XCTest
@testable import SwiftUITCASample
import ComposableArchitecture

class SwiftUITCASampleTests: XCTestCase {
    func testCompletingToDo() {
        let uuid = UUID.init()
        let store = TestStore(
            initialState: AppState(
                todoStates: [
                    ToDoState(
                        id: uuid,
                        description: "ToDo 1",
                        isCompleted: false
                    ),
                    ToDoState(
                        id: uuid,
                        description: "ToDo 2",
                        isCompleted: false
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { uuid }
            )
        )
        store.assert(
            .send(.todo(index: 0, action: .checkTapped)) { step in
                step.todoStates[0].description = "ToDo 2"
                step.todoStates[0].isCompleted = false
                step.todoStates[1].description = "ToDo 1"
                step.todoStates[1].isCompleted = true
            }
        )
        store.assert(
            .send(.todo(index: 0, action: .checkTapped)) { step in
                step.todoStates[0].description = "ToDo 1"
                step.todoStates[0].isCompleted = true
                step.todoStates[1].description = "ToDo 2"
                step.todoStates[1].isCompleted = true
            }
        )
    }

    func testAddToDo() {
        let uuid = UUID.init()
        let store = TestStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: { uuid }
            )
        )
        store.assert(
            .send(.addButtonTapped) { step in
                step.todoStates = [
                    ToDoState(
                        id: uuid,
                        description: "",
                        isCompleted: false
                    )
                ]
            }
        )
    }
}
