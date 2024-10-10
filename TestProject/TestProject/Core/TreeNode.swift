//
//  TreeNode.swift
//  TestProject
//
//  Created by Alexander Martirosov on 10/9/24.
//

import Foundation
import Combine

final class TreeNode: ObservableObject {
    var node: DbNode
    
    var id: UUID { node.id }
    var parentId: UUID? { node.parentId }
    var value: String { node.value }
    @Published var children: [TreeNode] = []
    
    init(node: DbNode) {
        self.node = node
    }
    
    func addChild(_ child: TreeNode) {
        children.append(child)
    }
    
    func delete() {
        node.isDeleted = true
        objectWillChange.send()
        for child in children {
            child.delete()
        }
    }
    
    func update(newValue: String) {
        node.value = newValue
        objectWillChange.send()
    }
}

extension TreeNode: Identifiable { }
