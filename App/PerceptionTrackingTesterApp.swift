//
//  PerceptionTrackingTesterApp.swift
//  PerceptionTrackingTester
//
//  Created by Jonathan on 12/1/23.
//

import SwiftUI
import ComposableArchitecture
import ParentFeature

@main
struct PerceptionTrackingTesterApp: App {
    var body: some Scene {
        WindowGroup {
            ParentView(store: Store(initialState: ParentFeature.State(), reducer: {
                ParentFeature()
            }))
        }
    }
}
