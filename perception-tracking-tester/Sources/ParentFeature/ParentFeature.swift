//
//  TestFeature.swift
//  PerceptionTrackingTester
//
//  Created by Jonathan on 12/1/23.
//

import ComposableArchitecture
import Foundation
import ChildFeature



@Reducer
public struct ParentFeature {
    @Dependency(\.dataSource) var dataSource
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destinations.State?
        var items =  [TestItem]()
        var path = StackState<Path.State>()
        
        public init(){}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case path(StackAction<Path.State, Path.Action>)
        case showChildPressed(UUID)
        case listItemTapped(UUID)
        case dataUpdated([TestItem]?)
        case destination(PresentationAction<Destinations.Action>)
        case task
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .task:
                return .run { send in
                    
                    dataSource.generateData()
                    
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask {
                            for await items in dataSource.publisher().values {
                                await send(.dataUpdated(items))
                            }
                        }
                    }
                }
                
                
            case let .dataUpdated(items):
                if let items {
                    state.items = items
                }
                return .none
                
            case .binding:
                return .none
                
            case .path:
                return .none
                
            case .showChildPressed(let uuid):
                state.destination = .childFeature(ChildFeature.State(childValue: uuid, date: Date.now))
                return .none
                
            case .listItemTapped(let uuid):
                state.path.append(.childFeature(ChildFeature.State(childValue: uuid, date: Date.now)))
                return .none
                
            case .destination:
                return .none
            }
        }
        
        .ifLet(\.$destination, action: \.destination){
            Destinations()
        }
        
        .forEach(\.path, action: \.path) {
            Path()
        }
        
    }

    
    
    
    @Reducer
    public struct Destinations {
        
        public enum State: Equatable {
            case childFeature(ChildFeature.State)
        }
        
        public enum Action: Equatable {
            case childFeature(ChildFeature.Action)
            
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.childFeature, action: \.childFeature) {
                ChildFeature()
            }
        }
    }
    
    @Reducer
    public struct Path {
        
        @ObservableState
        public enum State: Equatable {
            case childFeature(ChildFeature.State)
        }
        
        public enum Action: Equatable {
            case childFeature(ChildFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.childFeature, action: \.childFeature) {
                ChildFeature()
            }
        }
    }
}
