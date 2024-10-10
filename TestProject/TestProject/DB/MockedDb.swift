//
//  MockedDb.swift
//  TestProject
//
//  Created by Alexander Martirosov on id10/id9/24.
//

import Foundation

class MockedDb {
    static var nodes = Set<DbNode>()
    
    static func populateDb() {
        // Adding the root node
        let id1 = UUID()
        nodes.insert(DbNode.mock(id: id1, parentId: nil))
        
        // Level 2
        let id2 = UUID()
        nodes.insert(DbNode.mock(id: id2, parentId: id1))
        let id3 = UUID()
        nodes.insert(DbNode.mock(id: id3, parentId: id1))
        
        // Level 3
        let id4 = UUID()
        nodes.insert(DbNode.mock(id: id4, parentId: id2))
        let id5 = UUID()
        nodes.insert(DbNode.mock(id: id5, parentId: id2))
        let id6 = UUID()
        nodes.insert(DbNode.mock(id: id6, parentId: id3))
        let id7 = UUID()
        nodes.insert(DbNode.mock(id: id7, parentId: id3))
        
        // Level 4
        let id8 = UUID()
        nodes.insert(DbNode.mock(id: id8, parentId: id4))
        let id9 = UUID()
        nodes.insert(DbNode.mock(id: id9, parentId: id4))
        let id10 = UUID()
        nodes.insert(DbNode.mock(id: id10, parentId: id5))
        let id11 = UUID()
        nodes.insert(DbNode.mock(id: id11, parentId: id5))
        let id12 = UUID()
        nodes.insert(DbNode.mock(id: id12, parentId: id6))
        let id13 = UUID()
        nodes.insert(DbNode.mock(id: id13, parentId: id6))
        let id14 = UUID()
        nodes.insert(DbNode.mock(id: id14, parentId: id7))
        let id15 = UUID()
        nodes.insert(DbNode.mock(id: id15, parentId: id7))
        
        // More nodes for the fourth level, distributed across nodes
        nodes.insert(DbNode.mock(id: UUID(), parentId: id8))
        nodes.insert(DbNode.mock(id: UUID(), parentId: id9))
        nodes.insert(DbNode.mock(id: UUID(), parentId: id10))
        nodes.insert(DbNode.mock(id: UUID(), parentId: id11))
        nodes.insert(DbNode.mock(id: UUID(), parentId: id12))
    }
}

private extension DbNode {
    static func mock(id: UUID, parentId: UUID?) -> DbNode {
        return .init(id: id, parentId: parentId, value: "I'm node with id ~ \(mapUUIDToNumber(uuid: id))")
    }
    
    private static func mapUUIDToNumber(uuid: UUID, range: ClosedRange<Int> = 0...1000) -> Int {
        // Convert UUID to a string and hash it to a numeric value
        let uuidString = uuid.uuidString
        let hashValue = uuidString.hashValue

        // Use modulo to map the hash value to the desired range
        let mappedValue = abs(hashValue % (range.upperBound - range.lowerBound + 1)) + range.lowerBound
        return mappedValue
    }
}
