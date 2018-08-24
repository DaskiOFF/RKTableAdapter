import Foundation

/// Changes rows in section(s)
struct RowsChanges: CustomStringConvertible {
    /// from (IndexPath before deletes), to (IndexPath after update)
    struct Move: Equatable {
        var from: IndexPath
        var to: IndexPath
    }

    struct Update: Equatable {
        var old: IndexPath?
        var new: IndexPath
    }

    /// IndexPaths before update
    var deletes: [IndexPath] = []
    /// IndexPaths after update
    var inserts: [IndexPath] = []
    /// IndexPaths after update
    var updates: [Update] = []
    /// IndexPath `from` before update, IndexPath `to` after update
    var moves: [Move] = []

    func insert(_ new: RowsChanges) -> RowsChanges {
        var result = self

        result.deletes.append(contentsOf: new.deletes)
        result.inserts.append(contentsOf: new.inserts)
        result.updates.append(contentsOf: new.updates)
        result.moves.append(contentsOf: new.moves)

        return result
    }

    func sorted() -> RowsChanges {
        var sortedResult = self

        sortedResult.deletes = sortedResult.deletes.sorted(by: >)
        sortedResult.inserts = sortedResult.inserts.sorted(by: <)

        return sortedResult
    }

    // MARK: - CustomStringConvertible
    var description: String {
        let changedUpdatesForDescription = updates.map({ update -> String in
            var result = "nil"
            if let old = update.old {
                result = "\(old.section):\(old.row)"
            }
            return "\(result) - \(update.new.section):\(update.new.row)"
        })

        return """
        deletes: [\(deletes.map { "\($0.section):\($0.row)" })]
        insert: [\(inserts.map { "\($0.section):\($0.row)" })]
        moves: [\(moves.map { "\($0.from.section):\($0.from.row) -> \($0.to.section):\($0.to.row)" })]
        updates: [\(changedUpdatesForDescription)]
        """
    }
}
