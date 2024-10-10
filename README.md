# TestTask

**The project created with XCode 16.0**

For simplicity, a node of the tree is represented by a row with the following fields:

- Id: UUID
- ParentId: UUID (*optional*)
- Value: String
- IsDeleted: Bool

Each time a user selects (fetches) a node from the database, it either becomes the root for a new tree in the editor or
is attached to its parent (if the parent is already present in the editor).

When a user deletes a node, the node and its descendants (recursively) are marked as deleted.

Every operation with a tree in the editor is added to the operation queue. When the user commits all changes, all
operations from the queue are applied to the database one by one.