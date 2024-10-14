//
//  TreeManagerProvider.swift
//  TestProject
//
//  Created by Alexander Martirosov on 10/14/24.
//

import Foundation

protocol TreeManagerProvider {
	var rootNodes: [TreeNode] { get }
	func build(nodes: [DbNode])
	func reset()
	func node(by id: UUID) -> TreeNode?
	func add(node: DbNode)
	func allDeletedNodes() -> [TreeNode]
	func update(with deleted: [UUID])
	func add(value: String, parentId: UUID) -> DbNode
	func delete(node: TreeNode)
	func update(node: TreeNode, withValue newValue: String)
}
