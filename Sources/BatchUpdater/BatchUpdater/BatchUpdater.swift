//
//  BatchUpdater.swift
//  TestBatchUpdate
//
//  Created by Roman Kotov on 14/07/2018.
//  Copyright © 2018 Roman Kotov. All rights reserved.
//

import Foundation
import UIKit

protocol BatchUpdateSection: DeepHashable {
    func getRows() -> [DeepHashable]
}

class BatchUpdater {
    public func batchUpdate(tableView: UITableView, oldSections: [BatchUpdateSection], newSections: [BatchUpdateSection], completion: ((Bool) -> Void)?) {
        let changes = self.changes(forOldSection: oldSections, and: newSections)
        tableView.performBatchUpdates(sectionsChanges: changes.sectionsChanges,
                                     sectionChanges: changes.rowsChanges,
                                     completion: completion)
    }

    public func batchUpdate(collectionView: UICollectionView, oldSections: [BatchUpdateSection], newSections: [BatchUpdateSection], completion: ((Bool) -> Void)?) {
        let changes = self.changes(forOldSection: oldSections, and: newSections)
        collectionView.performBatchUpdates(sectionsChanges: changes.sectionsChanges,
                                     sectionChanges: changes.rowsChanges,
                                     completion: completion)
    }

    // MARK: - Private
    func changes(forOldSection oldSections: [BatchUpdateSection], and newSections: [BatchUpdateSection]) -> (sectionsChanges: SectionsChanges, rowsChanges: SectionChanges) {
        let changesSections = diffSet(oldList: oldSections.map({ Box(value: $0) }),
                                      list: newSections.map({ Box(value: $0) }))
        var rowsChanges = SectionChanges()

        let hashsSectionsReloads = deepHashsSectionsReloads(for: changesSections,
                                                            oldList: oldSections,
                                                            newList: newSections)

        for (index, section) in newSections.enumerated() {
            guard !hashsSectionsReloads.contains(section.deepDiffHash) else { continue }
            guard let oldSectionInfo = oldSections.enumerated().first(where: { $0.element.deepDiffHash == section.deepDiffHash }) else { continue }

            let oldSectionRows = oldSectionInfo.element.getRows()
            let newSectionRows = section.getRows()

            let changes = diffIndexPath(oldList: oldSectionRows.map({ Box(value: $0) }),
                                        list: newSectionRows.map({ Box(value: $0) }),
                                        oldSectionIndex: oldSectionInfo.offset,
                                        newSectionIndex: index)
            rowsChanges = rowsChanges.insert(changes)
        }

        return (changesSections, rowsChanges)
    }

    private func deepHashsSectionsReloads(for sectionsChanges: SectionsChanges,
                                          oldList: [DeepHashable],
                                          newList: [DeepHashable]) -> Set<Int> {
        var ids: Set<Int> = []

        for index in sectionsChanges.deletes { ids.insert(oldList[index].deepDiffHash) }
        for index in sectionsChanges.inserts { ids.insert(newList[index].deepDiffHash) }
        for index in sectionsChanges.updates { ids.insert(newList[index].deepDiffHash) }

        return ids
    }

    private func diffSet(oldList: [DeepHashable], list: [DeepHashable]) -> SectionsChanges {
        let diffResult = diff(old: oldList.map({ Box(value: $0) }),
                              new: list.map({ Box(value: $0) }))

        var sectionsChanges = SectionsChanges()

        for changeValue in diffResult {
            switch changeValue {
            case .delete(let del):
                sectionsChanges.deletes.insert(del.index)

            case .insert(let ins):
                sectionsChanges.inserts.insert(ins.index)

            case .move(let move):
                let fromIndex = oldList.index(where: { $0.deepDiffHash == move.item.deepDiffHash })!
                let toIndex = list.index(where: { $0.deepDiffHash == move.item.deepDiffHash })!
                guard fromIndex != toIndex else { continue }
                sectionsChanges.moves.append(SectionsChanges.Move.init(from: fromIndex, to: toIndex))

            case .replace(let repl):
                let newIndex = list.index(where: { $0.deepDiffHash == repl.newItem.deepDiffHash })!
                sectionsChanges.updates.insert(newIndex)
            }
        }

        var filteredMoves = sectionsChanges.moves
        var filteredUpdates = sectionsChanges.updates

        // convert all update+move to delete+insert
        let moveCount = sectionsChanges.moves.count
        for i in stride(from: moveCount - 1, through: 0, by: -1) {
            let move = sectionsChanges.moves[i]
            if filteredUpdates.contains(move.to) {
                filteredMoves.remove(at: i)
                filteredUpdates.remove(move.to)
                sectionsChanges.deletes.insert(move.from)
                sectionsChanges.inserts.insert(move.to)
            }
        }

        // iterate all new identifiers. if its index is updated, delete from the old index and insert the new index
        for newListIndex in 0..<list.count {
            if filteredUpdates.contains(newListIndex) {
                filteredUpdates.remove(newListIndex)
                guard let oldListIndex = oldList.index(where: { $0.deepDiffHash == list[newListIndex].deepDiffHash }) else {
                    continue
                }
                sectionsChanges.deletes.insert(oldListIndex)
                sectionsChanges.inserts.insert(newListIndex)
            }
        }

        sectionsChanges.moves = filteredMoves
        sectionsChanges.updates = filteredUpdates

        return sectionsChanges
    }

    private func diffIndexPath<T: DeepHashable>(oldList: [T],
                       list: [T],
                       oldSectionIndex: Int,
                       newSectionIndex: Int) -> SectionChanges {
        let diffResult = diff(old: oldList, new: list)

        var sectionChanges = SectionChanges()

        for changeValue in diffResult {
            switch changeValue {
            case .delete(let del):
                sectionChanges.deletes.append(IndexPath(row: del.index, section: oldSectionIndex))

            case .insert(let ins):
                sectionChanges.inserts.append(IndexPath(row: ins.index, section: newSectionIndex))

            case .move(let move):
                sectionChanges.moves.append(SectionChanges.Move(from: IndexPath(row: move.fromIndex, section: oldSectionIndex),
                                                                to: IndexPath(row: move.toIndex, section: newSectionIndex)))

            case .replace(let repl):
                sectionChanges.updates.append(IndexPath(row: repl.index, section: newSectionIndex))
            }
        }

        var deletesInSection = sectionChanges.deletes.enumerated().filter({ $0.element.section == oldSectionIndex })
        var insertsInSection = sectionChanges.inserts.enumerated().filter({ $0.element.section == newSectionIndex })
        for i in stride(from: deletesInSection.count - 1, through: 0, by: -1) {
            let delete = deletesInSection[i]
            for j in stride(from: insertsInSection.count - 1, through: 0, by: -1) {
                let insert = insertsInSection[j]

                if delete.element.row == insert.element.row {
                    sectionChanges.updates.append(IndexPath(row: insert.element.row, section: insert.element.section))
                    sectionChanges.deletes.remove(at: delete.offset)
                    sectionChanges.inserts.remove(at: insert.offset)
                    break
                }
            }
        }

        return sectionChanges
    }
}
