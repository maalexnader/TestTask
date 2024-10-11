//
//  TreeNodeView.swift
//  TestProject
//
//  Created by Alexander Martirosov on 10/9/24.
//

import SwiftUI

struct TreeNodeView: View {
    @ObservedObject var node: TreeNode
    let tapAction: (TreeNode) -> Void
    let selectedId: UUID?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Button(action: { tapAction(node) }) {
                Text(node.value)
                    .foregroundStyle(node.node.isDeleted ? .red : selectedId == node.id ? .green : .primary)
                    .font(.headline)
                    .padding(.vertical, 2)
            }
            
            if !node.children.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(node.children) { child in
                        TreeNodeView(node: child, tapAction: tapAction, selectedId: selectedId)
                            .padding(.leading, 20)
                    }
                }
            }
        }
    }
}

#Preview {
    TreeNodeView(
        node: .init(node: .init(id: UUID(), parentId: nil, value: "Root")),
        tapAction: { _ in },
        selectedId: nil
    )
}
