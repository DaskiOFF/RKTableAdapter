import UIKit

class CollectionViewAdapterDelegate: NSObject,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    // MARK: - Properties
    unowned var holder: CollectionViewAdapter
    var automaticHeaderFooterHeight: CGFloat = 0

    // MARK: - Init
    init(holder: CollectionViewAdapter) {
        self.holder = holder
    }

    // MARK: - getters
    private func section(for index: Int) -> CollectionSection? {
        guard index < holder.list.sections.count else { return nil }
        return holder.list.sections[index]
    }

    private func row(for section: CollectionSection, index: Int) -> CollectionItemConfigurable? {
        guard index < section.numberOfRows else { return nil }
        return section.rows[index]
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    // MARK: Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = holder.list.sections[indexPath.section].rows[indexPath.row]

        guard let size = row.cellVM.defaultSize ?? row.cellVM.estimatedSize else {
            fatalError("Need size for cell")
        }
        return size
    }

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    // MARK: Selecting
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
            else { return }

        if row.cellVM.deselectAutomatically {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        row.cellVM.action?(row.cellVM.userInfo ?? row.cellVM)
    }



    // MARK: Number sections, items
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return holder.list.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return holder.list.sections[section].numberOfRows
    }

    // MARK: Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let row = section(for: indexPath.section)?.rows[indexPath.row] else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.reuseId, for: indexPath)

        row.configure(collectionCell: cell)
        if let bindingCell = cell as? BindingCell & ConfigureCell {
            row.cellVM.bind(view: bindingCell)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let row = section(for: indexPath.section)?.rows[indexPath.row] else { return }

        if let bindingCell = cell as? BindingCell & ConfigureCell {
            row.cellVM.bind(view: bindingCell)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let bindingCell = cell as? BindingCell {
            bindingCell.unbind()
        }
    }

    // MARK: - ScroolViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        holder.scrollViewCallbacks.scrollViewDidScroll?(scrollView)
    }
}
