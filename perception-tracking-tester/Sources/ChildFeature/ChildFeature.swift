//
//  File.swift
//  
//
//  Created by Jonathan on 12/5/23.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct ChildFeature: Reducer {
    @Dependency(\.dismiss) var dismiss
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var childValue: UUID
        var date: Date
        public init(childValue: UUID, date: Date) {
            self.childValue = childValue
            self.date = date
        }
    }
    
    public enum Action: Equatable {
        case dismiss
    }
    
    public var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
            case .dismiss:
                return .run { send in
                    await self.dismiss()
                }
            }
        }
    }
}

