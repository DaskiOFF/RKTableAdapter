import UIKit

extension UICollectionView {
    func performBatchUpdates(sectionsChanges: SectionsChanges, rowsChanges: RowsChanges, completion: ((Bool) -> Void)?) {
        performBatchUpdates({
            updateActions(sectionsChanges: sectionsChanges, rowsChanges: rowsChanges)
        }, completion: completion)

        reloadItems(at: rowsChanges.updates.map { $0.new })
    }

    // MARK: - Private
    private func updateActions(sectionsChanges: SectionsChanges, rowsChanges: RowsChanges) {
        // sections
        deleteSections(sectionsChanges.deletes)
        insertSections(sectionsChanges.inserts)
        for move in sectionsChanges.moves {
            moveSection(move.from, toSection: move.to)
        }
        reloadSections(sectionsChanges.updates)

        // items
        deleteItems(at: rowsChanges.deletes)
        insertItems(at: rowsChanges.inserts)
        for move in rowsChanges.moves {
            guard !sectionsChanges.deletes.contains(move.from.row) && !sectionsChanges.inserts.contains(move.to.row) else {
                continue
            }
            moveItem(at: move.from, to: move.to)
        }
    }
}
