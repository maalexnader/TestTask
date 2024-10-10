//
//  Operation.swift
//  TestProject
//
//  Created by Alexander Martirosov on 10/9/24.
//

enum Operation {
    case delete(DbNode)
    case edit(DbNode, String)
    case add(DbNode)
}
