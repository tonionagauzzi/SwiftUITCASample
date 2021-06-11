//
//  SwiftUITCASampleApp.swift
//  SwiftUITCASample
//
//  Created by K Nagauchi on 2021/06/11.
//

import SwiftUI
import ComposableArchitecture

@main
struct SwiftUITCASampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store<AppState, AppAction>(
               initialState: AppState(),
               reducer: appReducer,
               environment: AppEnvironment()
            ))
        }
    }
}
