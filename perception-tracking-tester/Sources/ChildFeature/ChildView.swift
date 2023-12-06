//
//  File.swift
//  
//
//  Created by Jonathan on 12/5/23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct ChildView: View {
    let currentDate = Date()
    
    @State var store: StoreOf<ChildFeature> = Store(initialState: ChildFeature.State(childValue: UUID(), date: Date.now.addingTimeInterval(86400))) {
        ChildFeature()
    }
    
    public init(store: StoreOf<ChildFeature>) {
        self.store = store
    }
    
   public var body: some View {
        WithPerceptionTracking {
            VStack {
                Text(store.childValue.uuidString)
                Text(store.date.formatted())
                Button("Dismiss Me") {
                    store.send(.dismiss)
                }
            }
            
        }
        
    }
}
