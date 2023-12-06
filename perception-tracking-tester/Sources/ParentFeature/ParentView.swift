//
//  TestView.swift
//  PerceptionTrackingTester
//
//  Created by Jonathan on 12/1/23.
//

import SwiftUI
import ComposableArchitecture
import ChildFeature

public struct ParentView: View {
    @State var store: StoreOf<ParentFeature> = Store(initialState: ParentFeature.State()) {
        ParentFeature()
    }
    
    public init(store: StoreOf<ParentFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                List {
                    ForEach(store.items) { item in
                        VStack {
                            Button("Show in Sheet") {
                                store.send(.showChildPressed(item.id))
                            }
                            
                            
                            Button("Navigate") {
                                store.send(.listItemTapped(item.id)) // <--- PerceptionTracking Warning Here
                            }
                            
                            Text(item.id.uuidString)
                            
                            Text(item.date.formatted())
                            
                        }
                        .buttonStyle(BorderlessButtonStyle())
                            
                        
                    }
                }
                
               
                .sheet(item: $store.scope(state: \.destination?.childFeature, action: \.destination.childFeature)) {
                    ChildView(store: $0)
                }
                
                .task {
                    await store.send(.task).finish()
                }
                
                .navigationTitle("PerceptionTracking Tester")
                
            } destination: { store in
                switch store.state {
                case .childFeature:
                    if let childFeatureStore = store.scope(state: \.childFeature, action: \.childFeature) {
                        ChildView(store: childFeatureStore)
                    }
                }
            }
            
            
        }
        
    }
}
