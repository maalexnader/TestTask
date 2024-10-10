//
//  TreeManager.swift
//  TestProject
//
//  Created by Alexander Martirosov on 10/9/24.
//

import Foundation
import Combine

final class TreeManager: ObservableObject {
    private var nodesById: [UUID: TreeNode] = [:]
    private var pendingChildren: [UUID: [TreeNode]] = [:]
    
    @Published var rootNodes: [TreeNode] = []
    
    func build(nodes: Set<DbNode>) {
        nodesById = [:]
        rootNodes = []
        pendingChildren = [:]
        
        for node in nodes {
            let treeNode = TreeNode(node: node)
            nodesById[treeNode.id] = treeNode
        }

        for treeNode in nodesById.values {
            attachNode(treeNode)
        }
    }
    
    func node(by id: UUID) -> TreeNode? {
        nodesById[id]
    }
    
    func add(node: DbNode) {
        guard nodesById[node.id] == nil else { return }
        
        let treeNode = TreeNode(node: node)
        nodesById[treeNode.id] = treeNode
        attachNode(treeNode)
    }
    
    func add(value: String, parentId: UUID) -> DbNode {
        let node: DbNode = .init(id: UUID(), parentId: parentId, value: value)
        add(node: node)
        return node
    }
    
    func delete(node: TreeNode) {
        node.delete()
    }
    
    func update(node: TreeNode, withValue newValue: String) {
        node.update(newValue: newValue)
    }

    private func attachNode(_ treeNode: TreeNode) {
        if let parentId = treeNode.parentId {
            if let parentNode = nodesById[parentId] {
                parentNode.addChild(treeNode)
            } else {
                pendingChildren[parentId, default: []].append(treeNode)
                rootNodes.append(treeNode)
            }
        } else {
            rootNodes.append(treeNode)
        }

        if let children = pendingChildren[treeNode.id] {
            for child in children {
                if let index = rootNodes.firstIndex(where: { $0.id == child.id }) {
                    rootNodes.remove(at: index)
                }
                treeNode.addChild(child)
            }
            pendingChildren.removeValue(forKey: treeNode.id)
        }
    }
}
