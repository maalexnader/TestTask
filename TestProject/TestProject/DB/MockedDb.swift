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
        nodes.insert(DbNode.mock(id: id1, parentId: nil, name: 1))

        // Level 2
        let id2 = UUID()
        nodes.insert(DbNode.mock(id: id2, parentId: id1, name: 2))
        let id3 = UUID()
        nodes.insert(DbNode.mock(id: id3, parentId: id1, name: 3))

        // Level 3
        let id4 = UUID()
        nodes.insert(DbNode.mock(id: id4, parentId: id2, name: 4))
        let id5 = UUID()
        nodes.insert(DbNode.mock(id: id5, parentId: id2, name: 5))
        let id6 = UUID()
        nodes.insert(DbNode.mock(id: id6, parentId: id3, name: 6))
        let id7 = UUID()
        nodes.insert(DbNode.mock(id: id7, parentId: id3, name: 7))

        // Level 4
        let id8 = UUID()
        nodes.insert(DbNode.mock(id: id8, parentId: id4, name: 8))
        let id9 = UUID()
        nodes.insert(DbNode.mock(id: id9, parentId: id4, name: 0))
        let id10 = UUID()
        nodes.insert(DbNode.mock(id: id10, parentId: id5, name: 10))
        let id11 = UUID()
        nodes.insert(DbNode.mock(id: id11, parentId: id5, name: 11))
        let id12 = UUID()
        nodes.insert(DbNode.mock(id: id12, parentId: id6, name: 12))
        let id13 = UUID()
        nodes.insert(DbNode.mock(id: id13, parentId: id6, name: 13))
        let id14 = UUID()
        nodes.insert(DbNode.mock(id: id14, parentId: id7, name: 14))
        let id15 = UUID()
        nodes.insert(DbNode.mock(id: id15, parentId: id7, name: 15))

        nodes.insert(DbNode.mock(id: UUID(), parentId: id8, name: 16))
        nodes.insert(DbNode.mock(id: UUID(), parentId: id9, name: 17))
        nodes.insert(DbNode.mock(id: UUID(), parentId: id10, name: 18))
        nodes.insert(DbNode.mock(id: UUID(), parentId: id11, name: 19))
        nodes.insert(DbNode.mock(id: UUID(), parentId: id12, name: 20))
    }
}

private extension DbNode {
    static func mock(id: UUID, parentId: UUID?, name: Int) -> DbNode {
        return .init(id: id, parentId: parentId, value: "I'm node with id: \(name)")
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
