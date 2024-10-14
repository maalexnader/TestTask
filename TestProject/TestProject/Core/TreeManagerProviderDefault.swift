//
//  TreeManagerProvider.swift
//  TestProject
//
//  Created by Alexander Martirosov on 10/14/24.
//

import Foundation

final class TreeManagerProviderDefault: TreeManagerProvider {
    private var nodesById: [UUID: TreeNode] = [:]
    private var pendingChildren: [UUID: [TreeNode]] = [:]
	
	var rootNodes: [TreeNode] = []
	
	func build(nodes: [DbNode]) {
		nodesById = [:]
		rootNodes = []
		pendingChildren = [:]
		
		for node in nodes {
			let treeNode = TreeNode(node: node)
			nodesById[treeNode.id] = treeNode
		}
		
		for treeNode in nodesById.values.sorted(by: { lhs, rhs in
			lhs.node.id < rhs.node.id
		}) {
			attachNode(treeNode)
		}
	}
	
	func reset() {
		nodesById = [:]
		rootNodes = []
		pendingChildren = [:]
	}
	
	func node(by id: UUID) -> TreeNode? {
		nodesById[id]
	}
	
	func add(node: DbNode) {
		guard nodesById[node.id] == nil else { return }
		
		if let parentId = node.parentId, let parentNode = nodesById[parentId] {
			let treeNode = TreeNode(node: node.with(isDeleted: parentNode.node.isDeleted))
			nodesById[node.id] = treeNode
			attachNode(treeNode)
		} else {
			let treeNode = TreeNode(node: node)
			nodesById[node.id] = treeNode
			attachNode(treeNode)
		}
	}
	
	func allDeletedNodes() -> [TreeNode] {
		return nodesById.values.filter { $0.node.isDeleted }
	}
	
	func update(with deleted: [UUID]) {
		let deletedSet = Set(deleted)
		for rootNode in rootNodes {
			update(node: rootNode, deleted: deletedSet, parent: nil)
		}
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
	
	private func update(node: TreeNode, deleted: Set<UUID>, parent: TreeNode?) {
		if deleted.contains(node.id) {
			node.delete()
			if let parentNode = parent {
				for sibling in parentNode.children {
					if sibling.id != node.id {
						sibling.delete()
					}
				}
			}
		}
		
		for child in node.children {
			update(node: child, deleted: deleted, parent: node)
		}
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
				if treeNode.node.isDeleted {
					child.delete()
				}
				treeNode.addChild(child)
			}
			pendingChildren.removeValue(forKey: treeNode.id)
		}
	}
}
