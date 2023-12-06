//
//  DataSource.swift
//  PerceptionTrackingTester
//
//  Created by Jonathan on 12/4/23.
//

import Foundation
import Dependencies
import Combine

public struct TestItem: Identifiable, Equatable {
    public let id: UUID
    public let date: Date
    public let children: [TestItem]
    
}


extension DependencyValues {
    public var dataSource: DataSource  {
        get { self[DataSource.self] }
        set { self[DataSource.self] = newValue }
    }
}


public struct DataSource {
    public var generateData: @Sendable () -> Void
    public var publisher: @Sendable () -> AnyPublisher<[TestItem]?, Never>
    
}



extension DataSource: TestDependencyKey {
    public static var testValue: DataSource {
        return Self(
            generateData: XCTUnimplemented("\(Self.self).generateData"),
            publisher: XCTUnimplemented("\(Self.self).publisher")
        )
    }
}

extension DataSource: DependencyKey {
    public static let liveValue: Self = {
    
        let dataPublisher: CurrentValueSubject<[TestItem]?, Never> = CurrentValueSubject(nil)
        
        return Self(
            generateData: {
                var items = [TestItem]()
                for _ in 1...1000 {
                    var children = [TestItem]()
                    for _ in 1...10 {
                        children.append(.init(id: UUID(), date: Date(), children: []))
                    }
                    items.append(.init(id: UUID(), date: Date(), children: children))
                }
                
                dataPublisher.send(items)
            },
            publisher: {
                dataPublisher.eraseToAnyPublisher()
            }
            
        )
    }()
}

