//
//  SectionChanges.swift
//  TestBatchUpdate
//
//  Created by Roman Kotov on 14/07/2018.
//  Copyright © 2018 Roman Kotov. All rights reserved.
//

import Foundation

/// Changes rows in section(s)
struct SectionChanges {
    /// from (IndexPath before deletes), to (IndexPath after update)
    struct Move: Equatable {
        var from: IndexPath
        var to: IndexPath
    }

    /// IndexPaths before update
    var deletes: [IndexPath] = []
    /// IndexPaths after update
    var inserts: [IndexPath] = []
    /// IndexPaths after update
    var updates: [IndexPath] = []
    /// IndexPath `from` before update, IndexPath `to` after update
    var moves: [Move] = []

    func insert(_ new: SectionChanges) -> SectionChanges {
        var result = self

        result.deletes.append(contentsOf: new.deletes)
        result.inserts.append(contentsOf: new.inserts)
        result.updates.append(contentsOf: new.updates)
        result.moves.append(contentsOf: new.moves)

        return result
    }
}
