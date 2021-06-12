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
        let (uuid1, uuid2) = (UUID.init(), UUID.init())
        let store = TestStore(
            initialState: AppState(
                todoStates: [
                    ToDoState(
                        id: uuid1,
                        description: "ToDo 1",
                        isCompleted: false
                    ),
                    ToDoState(
                        id: uuid2,
                        description: "ToDo 2",
                        isCompleted: false
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment()
        )
        store.assert(
            .send(.todo(index: 0, action: .checkTapped)) { expected in
                expected.todoStates = [
                    ToDoState(
                        id: uuid2,
                        description: "ToDo 2",
                        isCompleted: false
                    ),
                    ToDoState(
                        id: uuid1,
                        description: "ToDo 1",
                        isCompleted: true
                    )
                ]
            }
        )
        store.assert(
            .send(.todo(index: 0, action: .checkTapped)) { expected in
                expected.todoStates = [
                    ToDoState(
                        id: uuid1,
                        description: "ToDo 1",
                        isCompleted: true
                    ),
                    ToDoState(
                        id: uuid2,
                        description: "ToDo 2",
                        isCompleted: true
                    )
                ]
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
            .send(.addButtonTapped) { expected in
                expected.todoStates = [
                    ToDoState(
                        id: uuid,
                        description: "",
                        isCompleted: false
                    )
                ]
            }
        )
    }
    
    func testRemoveToDo() {
        let (uuid1, uuid2) = (UUID.init(), UUID.init())
        let store = TestStore(
            initialState: AppState(
                todoStates: [
                    ToDoState(
                        id: uuid1,
                        description: "ToDo 1",
                        isCompleted: false
                    ),
                    ToDoState(
                        id: uuid2,
                        description: "ToDo 2",
                        isCompleted: true
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment()
        )
        store.assert(
            .send(.todo(index: 0, action: .removed)) { expected in
                expected.todoStates = [
                    ToDoState(
                        id: uuid2,
                        description: "ToDo 2",
                        isCompleted: true
                    )
                ]
            }
        )
    }
}
