import UIKit

extension UICollectionView {
    func performBatchUpdates(sectionsChanges: SectionsChanges, sectionChanges: SectionChanges, completion: ((Bool) -> Void)?) {
        performBatchUpdates({
            updateActions(sectionsChanges: sectionsChanges, sectionChanges: sectionChanges)
        }, completion: completion)
    }

    // MARK: - Private
    private func updateActions(sectionsChanges: SectionsChanges, sectionChanges: SectionChanges) {
        // sections
        deleteSections(sectionsChanges.deletes)
        insertSections(sectionsChanges.inserts)
        for move in sectionsChanges.moves {
            moveSection(move.from, toSection: move.to)
        }
        reloadSections(sectionsChanges.updates)

        // items
        deleteItems(at: sectionChanges.deletes)
        insertItems(at: sectionChanges.inserts)
        for move in sectionChanges.moves {
            guard !sectionsChanges.deletes.contains(move.from.row) && !sectionsChanges.inserts.contains(move.to.row) else {
                continue
            }
            moveItem(at: move.from, to: move.to)
        }
        reloadItems(at: sectionChanges.updates)
    }
}
