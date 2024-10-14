//
//  TreeManager.swift
//  TestProject
//
//  Created by Alexander Martirosov on 10/9/24.
//

import Foundation
import Combine

final class TreeManager: ObservableObject {
	private let provider: TreeManagerProvider
	
	@Published var rootNodes: [TreeNode] = []
	
	init(provider: TreeManagerProvider) {
		self.provider = provider
	}
	
	func build(nodes: [DbNode]) {
		provider.build(nodes: nodes)
		rootNodes = provider.rootNodes
	}
	
	func reset() {
		provider.reset()
		rootNodes = provider.rootNodes
	}
	
	func node(by id: UUID) -> TreeNode? {
		provider.node(by: id)
	}
	
	func add(node: DbNode) {
		provider.add(node: node)
		rootNodes = provider.rootNodes
	}
	
	func allDeletedNodes() -> [TreeNode] {
		provider.allDeletedNodes()
	}
	
	func update(with deleted: [UUID]) {
		provider.update(with: deleted)
		rootNodes = provider.rootNodes
	}
	
	func add(value: String, parentId: UUID) -> DbNode {
		let result = provider.add(value: value, parentId: parentId)
		rootNodes = provider.rootNodes
		return result
	}
	
	func delete(node: TreeNode) {
		provider.delete(node: node)
		rootNodes = provider.rootNodes
	}
	
	func update(node: TreeNode, withValue newValue: String) {
		provider.update(node: node, withValue: newValue)
		rootNodes = provider.rootNodes
	}
}
