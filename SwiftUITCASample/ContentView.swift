//
//  ContentView.swift
//  SwiftUITCASample
//
//  Created by K Nagauchi on 2021/06/11.
//

import SwiftUI
import ComposableArchitecture

struct ToDoState: Equatable, Identifiable {
    let id: UUID
    var description = ""
    var isCompleted = false
}

enum ToDoAction: Equatable {
    case checkTapped
    case textChanged(String)
}

struct ToDoEnvironment {
}

let todoReducer = Reducer<ToDoState, ToDoAction, ToDoEnvironment> {
    state, action, environment in
    switch action {
    case .checkTapped:
        state.isCompleted.toggle()
        return .none
    case .textChanged(let text):
        state.description = text
        return .none
    }
}

struct AppState: Equatable {
    var todoStates: [ToDoState] = []
}

enum AppAction: Equatable {
    case todo(index: Int, action: ToDoAction)
    case addButtonTapped
}

struct AppEnvironment {
    var uuid: () -> UUID = UUID.init
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    todoReducer.forEach(
        state: \AppState.todoStates,
        action: /AppAction.todo(index:action:),
        environment: { _ in ToDoEnvironment() }
    ),
    Reducer { state, action, environemnt in
        switch action {
        case .todo(index: _, action: .checkTapped):
            state.todoStates = state.todoStates
                .enumerated()
                .sorted {
                    (!$0.element.isCompleted && $1.element.isCompleted)
                        || $0.element.description.lowercased()
                        < $1.element.description.lowercased()
                        || $0.offset < $1.offset
                }
                .map (\.element)
            return .none
        case .todo(index: let index, action: let action):
            return .none
        case .addButtonTapped:
            state.todoStates.insert(ToDoState(id: environemnt.uuid()), at: 0)
            return .none
        }
    }
)
.debug()

struct ToDoSmallView: View {
    let store: Store<ToDoState, ToDoAction>
    var body: some View {
        WithViewStore(self.store) { todoViewStore in
            HStack {
                Button(action: { todoViewStore.send(.checkTapped) })
                {
                    Image(
                        systemName: todoViewStore.isCompleted
                            ? "checkmark.square" : "square"
                    )
                }
                .buttonStyle(PlainButtonStyle())
                TextField(
                    "Input description",
                    text: todoViewStore.binding(
                        get: \.description,
                        send: ToDoAction.textChanged
                    )
                )
            }
            .foregroundColor(todoViewStore.isCompleted ? .gray : nil)
        }
    }
}

struct ContentView: View {
    let store: Store<AppState, AppAction>
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
                    ForEachStore(
                        self.store.scope(
                            state: \.todoStates,
                            action: AppAction.todo(index:action:)
                        ),
                        content: ToDoSmallView.init(store:)
                    )
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("ToDo list")
                .navigationBarItems(trailing: Button(
                    action: {
                        viewStore.send(.addButtonTapped)
                    },
                    label: {
                        Text("Add ToDo")
                    }
                ))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store<AppState, AppAction>(
            initialState: AppState(
                todoStates: [
                    ToDoState(
                        id: UUID(),
                        description: "Eat",
                        isCompleted: true
                    ),
                    ToDoState(
                        id: UUID(),
                        description: "Play",
                        isCompleted: false
                    ),
                    ToDoState(
                        id: UUID(),
                        description: "Sleep",
                        isCompleted: false
                    )
                ]
            ),
            reducer: appReducer,
            environment: AppEnvironment()
        ))
    }
}
