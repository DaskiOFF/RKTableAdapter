import Foundation
import UIKit

protocol BatchUpdateSection: DeepHashable {
    func getRows() -> [DeepHashable]
}

class BatchUpdater {
    public func batchUpdate(tableView: UITableView, oldSections: [BatchUpdateSection], newSections: [BatchUpdateSection], completion: ((Bool) -> Void)?) {
        var changes = self.changes(forOldSection: oldSections, and: newSections)

        var filteredUpdates: [RowsChanges.Update] = []
        var changedData: [ChangedData] = []

        for updateInfo in changes.rowsChanges.updates {
            guard let oldIndexPath = updateInfo.old, let index = (tableView.indexPathsForVisibleRows ?? []).index(of: oldIndexPath) else {
                filteredUpdates.append(updateInfo)
                continue
            }

            guard let oldSections = oldSections as? [TableSection],
                let newSections = newSections as? [TableSection] else {
                    filteredUpdates.append(updateInfo)
                    continue
            }

            let oldRow = oldSections[oldIndexPath.section].rows[oldIndexPath.row]
            let newRow = newSections[updateInfo.new.section].rows[updateInfo.new.row]

            guard oldRow.deepDiffHash == newRow.deepDiffHash &&
                oldRow.cellVM.accessoryType == newRow.cellVM.accessoryType else {
                    filteredUpdates.append(updateInfo)
                    continue
            }
            let visibleCells = tableView.visibleCells
            if index < visibleCells.count {
                changedData.append(ChangedData(oldRow: oldRow,
                                               oldIndexPath: oldIndexPath,
                                               newRow: newRow,
                                               newIndexPath: updateInfo.new))
            } else {
                filteredUpdates.append(updateInfo)
            }
        }

        changes.rowsChanges.updates = filteredUpdates
        tableView.performBatchUpdates(sectionsChanges: changes.sectionsChanges,
                                      rowsChanges: changes.rowsChanges,
                                      changedData: changedData,
                                      completion: completion)
    }

    public func batchUpdate(collectionView: UICollectionView, oldSections: [BatchUpdateSection], newSections: [BatchUpdateSection], completion: ((Bool) -> Void)?) {
        let changes = self.changes(forOldSection: oldSections, and: newSections)
        collectionView.performBatchUpdates(sectionsChanges: changes.sectionsChanges,
                                     rowsChanges: changes.rowsChanges,
                                     completion: completion)
    }

    // MARK: - Private
    func changes(forOldSection oldSections: [BatchUpdateSection], and newSections: [BatchUpdateSection]) -> (sectionsChanges: SectionsChanges, rowsChanges: RowsChanges) {
        var changesSections = diffSet(oldList: oldSections, list: newSections)
        var rowsChanges = RowsChanges()

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

        var updatedRowDeleteChanges: [IndexPath] = rowsChanges.deletes
        var updatedRowInsertChanges: [IndexPath] = rowsChanges.inserts
        var updatedSectionsMove: [SectionsChanges.Move] = []
        for sectionMove in changesSections.moves {
            var needDecomposite: Bool = false

            if updatedRowDeleteChanges.contains(where: { $0.section == sectionMove.from }) {
                updatedRowDeleteChanges = updatedRowDeleteChanges.filter({ $0.section != sectionMove.from })
                needDecomposite = true
            }

            if updatedRowInsertChanges.contains(where: { $0.section == sectionMove.to }) {
                updatedRowInsertChanges = updatedRowInsertChanges.filter({ $0.section != sectionMove.to })
                needDecomposite = true
            }

            if needDecomposite {
                changesSections.deletes.insert(sectionMove.from)
                changesSections.inserts.insert(sectionMove.to)
            } else {
                updatedSectionsMove.append(sectionMove)
            }
        }

        changesSections.moves = updatedSectionsMove
        rowsChanges.deletes = updatedRowDeleteChanges
        rowsChanges.inserts = updatedRowInsertChanges

        return (changesSections.sorted(), rowsChanges.sorted())
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
                       newSectionIndex: Int) -> RowsChanges {
        let diffResult = diff(old: oldList, new: list)

        var rowsChanges = RowsChanges()

        for changeValue in diffResult {
            switch changeValue {
            case .delete(let del):
                rowsChanges.deletes.append(IndexPath(row: del.index, section: oldSectionIndex))

            case .insert(let ins):
                rowsChanges.inserts.append(IndexPath(row: ins.index, section: newSectionIndex))

            case .move(let move):
                rowsChanges.moves.append(RowsChanges.Move(from: IndexPath(row: move.fromIndex, section: oldSectionIndex),
                                                                to: IndexPath(row: move.toIndex, section: newSectionIndex)))

            case .replace(let repl):
                let newIndex = repl.index
                guard let oldIndex = oldList.index(where: { $0.equal(object: repl.oldItem) }) else {
                    rowsChanges.updates.append(
                        RowsChanges.Update(old: nil, new: IndexPath(row: newIndex, section: newSectionIndex)))
                    break
                }
                rowsChanges.updates.append(
                    RowsChanges.Update(old: IndexPath(row: oldIndex, section: oldSectionIndex),
                                          new: IndexPath(row: newIndex, section: newSectionIndex)))

            }
        }

        return rowsChanges
    }
}
