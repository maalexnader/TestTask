//
//  ContentView.swift
//  TestProject
//
//  Created by Alexander Martirosov on 10/9/24.
//

import SwiftUI

struct TreeEditorView: View {
	@State private var operations = Queue<Operation>()
	
	@State private var selectedNode: TreeNode?
	@State private var editingValue: String = ""
	@State private var newNodeValue: String = ""
	
	@StateObject private var treeManager: TreeManager
	@StateObject private var editor: TreeManager
	
	init(makeProvider: @escaping () -> TreeManagerProvider) {
		_treeManager = StateObject(wrappedValue: TreeManager(provider: makeProvider()))
		_editor = StateObject(wrappedValue: TreeManager(provider: makeProvider()))
	}
	
	var body: some View {
        VStack {
            HStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(treeManager.rootNodes) { root in
                            TreeNodeView(
                                node: root,
                                tapAction: { node in
                                    editor.add(node: node.node)
                                },
                                selectedId: nil
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 1)
                )
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(editor.rootNodes) { root in
                            TreeNodeView(
                                node: root,
                                tapAction: { node in
                                    selectedNode = node
                                    editingValue = node.value
                                },
                                selectedId: selectedNode?.id
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green, lineWidth: 1)
                )
                
                if let selectedNode {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ID: \(selectedNode.id)")
                            .font(.title2)
                            .foregroundStyle(Color.primary)
                        
                        TextField("Value", text: $editingValue)
                            .font(.title3)
                            .disabled(selectedNode.node.isDeleted)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Add new node")
                                .font(.body)
                                .foregroundStyle(Color.primary)
                            TextField("Value", text: $newNodeValue)
                                .font(.title3)
                                .disabled(selectedNode.node.isDeleted)
                            Button(action: {
                                let newNode = editor.add(value: newNodeValue, parentId: selectedNode.id)
                                operations.enqueue(.add(newNode))
                                newNodeValue = ""
                            }) {
                                Text("Add")
                                    .font(.title3)
                                    .foregroundStyle(Color.green)
                                    .frame(maxWidth: .infinity)
                            }
                            .disabled(selectedNode.node.isDeleted)
                        }
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                editor.delete(node: selectedNode)
                                operations.enqueue(.delete(selectedNode.node))
                            }) {
                                Image(systemName: "trash.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.red)
                            }
                            .buttonStyle(.plain)
                            .disabled(selectedNode.node.isDeleted)
                            
                            Button(action: {
                                editor.update(node: selectedNode, withValue: editingValue)
                                operations.enqueue(.edit(selectedNode.node, editingValue))
                            }) {
                                Image(systemName: "arrow.up.document")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.blue)
                            }
                            .buttonStyle(.plain)
                            .disabled(selectedNode.node.isDeleted)
                            
                            Spacer()
                        }
                    }
                    .frame(width: 256, alignment: .leading)
                }
            }
            .padding()
            .onAppear {
                MockedDb.populateDb()
                treeManager.build(nodes: MockedDb.nodes)
            }
            
            HStack {
                Button(action: {
					commit()
                }) {
                    Text("Commit")
                        .font(.headline)
                        .foregroundStyle(.blue)
                }
                
                Button(action: {
					reset()
                }) {
                    Text("Reset")
                        .font(.headline)
                        .foregroundStyle(.red)
                }
            }
            .padding(.vertical, 24)
        }
    }
	
	private func reset() {
		treeManager.reset()
		editor.reset()
		treeManager.build(nodes: MockedDb.nodes)
		selectedNode = nil
	}
	
	private func commit() {
		while !operations.isEmpty {
			if let operation = operations.dequeue() {
				switch operation {
				case .delete(let node):
					if let nodeToDelete = treeManager.node(by: node.id) {
						treeManager.delete(node: nodeToDelete)
					}
				case .edit(let node, let newValue):
					if let nodeToUpdate = treeManager.node(by: node.id) {
						nodeToUpdate.update(newValue: newValue)
					}
				case .add(let node):
					treeManager.add(node: node)
				}
			}
		}

		editor.update(with: treeManager.allDeletedNodes().map { $0.id })
	}
}

#Preview {
	TreeEditorView(makeProvider: { TreeManagerProviderDefault() })
}
