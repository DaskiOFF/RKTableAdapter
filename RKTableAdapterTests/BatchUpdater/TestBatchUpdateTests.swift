//
//  TestBatchUpdateTests.swift
//  TestBatchUpdateTests
//
//  Created by Roman Kotov on 14/07/2018.
//  Copyright © 2018 Roman Kotov. All rights reserved.
//

import XCTest
@testable import RKTableAdapter

class TestBatchUpdateTests: XCTestCase {

    let oldList = DataGenerator.generateViewModels1()
    let newList = DataGenerator.generateViewModels2()

    var batchUpdater: BatchUpdater?

    override func setUp() {
        super.setUp()

        batchUpdater = BatchUpdater()
    }
    
    override func tearDown() {
        batchUpdater = nil

        super.tearDown()
    }
    
    func test_ChangesSections_From_OldList_To_NewList() {
        let batchUpdaterResult = batchUpdater!.changes(forOldSection: oldList, and: newList)
        let batchSectionsSet = batchUpdaterResult.sectionsChanges
        let batchRowsIndexPaths = batchUpdaterResult.rowsChanges

        // sections
        let sectionsDeletes: IndexSet = [0, 1, 2]
        let sectionsInserts: IndexSet = [0, 1, 2, 3]
        let sectionsUpdates: IndexSet = []
        let sectionsMoves: [SectionsChanges.Move] = [SectionsChanges.Move(from: 3, to: 5)]
        XCTAssert(sectionsDeletes == batchSectionsSet.deletes,
                  "\(sectionsDeletes.map({ $0 })) != \(batchSectionsSet.deletes.map({ $0 }))")

        XCTAssert(sectionsInserts == batchSectionsSet.inserts,
                  "\(sectionsInserts.map({ $0 })) != \(batchSectionsSet.inserts.map({ $0 }))")

        XCTAssert(sectionsUpdates == batchSectionsSet.updates,
                  "\(sectionsUpdates.map({ $0 })) != \(batchSectionsSet.updates.map({ $0 }))")

        XCTAssert(sectionsMoves == batchSectionsSet.moves,
                  "\(sectionsMoves.map({ $0 })) != \(batchSectionsSet.moves.map({ $0 }))")

        // rows
        let rowsDeletes: [IndexPath] = []
        let rowsInserts: [IndexPath] = []
        let rowsUpdates: [IndexPath] = [IndexPath(row: 1, section: 5)]
        let rowsMoves: [RowsChanges.Move] = [RowsChanges.Move(from: IndexPath(row: 1, section: 5),
                                                                    to: IndexPath(row: 0, section: 6)),
                                                RowsChanges.Move(from: IndexPath(row: 0, section: 5),
                                                                    to: IndexPath(row: 1, section: 6))]
        XCTAssert(rowsDeletes == batchRowsIndexPaths.deletes,
                  "\(rowsDeletes.map({ $0 })) != \(batchRowsIndexPaths.deletes.map({ $0 }))")

        XCTAssert(rowsInserts == batchRowsIndexPaths.inserts,
                  "\(rowsInserts.map({ $0 })) != \(batchRowsIndexPaths.inserts.map({ $0 }))")

        XCTAssert(rowsUpdates == batchRowsIndexPaths.updates.map { $0.new },
                  "\(rowsUpdates.map({ $0 })) != \(batchRowsIndexPaths.updates.map({ $0 }))")

        XCTAssert(rowsMoves == batchRowsIndexPaths.moves,
                  "\(rowsMoves.map({ $0 })) != \(batchRowsIndexPaths.moves.map({ $0 }))")
    }

    func test_ChangesSections_From_NewList_To_OldList() {
        let batchUpdaterResult = batchUpdater!.changes(forOldSection: newList, and: oldList)
        let batchSectionsSet = batchUpdaterResult.sectionsChanges
        let batchRowsIndexPaths = batchUpdaterResult.rowsChanges

        // sections
        let sectionsDeletes: IndexSet = [0, 1, 2, 3]
        let sectionsInserts: IndexSet = [0, 1, 2]
        let sectionsUpdates: IndexSet = []
        let sectionsMoves: [SectionsChanges.Move] = [SectionsChanges.Move(from: 5, to: 3)]
        XCTAssert(sectionsDeletes == batchSectionsSet.deletes,
                  "\(sectionsDeletes.map({ $0 })) != \(batchSectionsSet.deletes.map({ $0 }))")

        XCTAssert(sectionsInserts == batchSectionsSet.inserts,
                  "\(sectionsInserts.map({ $0 })) != \(batchSectionsSet.inserts.map({ $0 }))")

        XCTAssert(sectionsUpdates == batchSectionsSet.updates,
                  "\(sectionsUpdates.map({ $0 })) != \(batchSectionsSet.updates.map({ $0 }))")

        XCTAssert(sectionsMoves == batchSectionsSet.moves,
                  "\(sectionsMoves.map({ $0 })) != \(batchSectionsSet.moves.map({ $0 }))")

        // rows
        let rowsDeletes: [IndexPath] = []
        let rowsInserts: [IndexPath] = []
        let rowsUpdates: [IndexPath] = [IndexPath(row: 1, section: 3)]
        let rowsMoves: [RowsChanges.Move] = [RowsChanges.Move(from: IndexPath(row: 1, section: 6),
                                                                    to: IndexPath(row: 0, section: 5)),
                                                RowsChanges.Move(from: IndexPath(row: 0, section: 6),
                                                                    to: IndexPath(row: 1, section: 5))]
        XCTAssert(rowsDeletes == batchRowsIndexPaths.deletes,
                  "\(rowsDeletes.map({ $0 })) != \(batchRowsIndexPaths.deletes.map({ $0 }))")

        XCTAssert(rowsInserts == batchRowsIndexPaths.inserts,
                  "\(rowsInserts.map({ $0 })) != \(batchRowsIndexPaths.inserts.map({ $0 }))")

        XCTAssert(rowsUpdates == batchRowsIndexPaths.updates.map { $0.new },
                  "\(rowsUpdates.map({ $0 })) != \(batchRowsIndexPaths.updates.map({ $0 }))")

        XCTAssert(rowsMoves == batchRowsIndexPaths.moves,
                  "\(rowsMoves.map({ $0 })) != \(batchRowsIndexPaths.moves.map({ $0 }))")
    }
}
