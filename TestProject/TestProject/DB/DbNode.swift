//
//  DbNode.swift
//  TestProject
//
//  Created by Alexander Martirosov on 10/9/24.
//

import Foundation

struct DbNode {
    let id: UUID
    let parentId: UUID?
    var value: String
    var isDeleted: Bool = false
}

extension DbNode: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
