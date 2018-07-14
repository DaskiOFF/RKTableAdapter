//
//  SectionsChanges.swift
//  TestBatchUpdate
//
//  Created by Roman Kotov on 14/07/2018.
//  Copyright © 2018 Roman Kotov. All rights reserved.
//

import Foundation

/// Changes in sections list
struct SectionsChanges {
    /// from (index before deletes), to (index after update)
    struct Move: Equatable {
        var from: Int
        var to: Int
    }

    /// Indexes before update
    var deletes: IndexSet = []
    /// Indexes after update
    var inserts: IndexSet = []
    /// Indexes after update
    var updates: IndexSet = []
    /// Index `from` before update, Index `to` after update
    var moves: [Move] = []
}
