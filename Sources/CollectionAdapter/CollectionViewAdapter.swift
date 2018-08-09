import Foundation
import UIKit

open class CollectionViewAdapter {

    // MARK: - Properties
    private var _list: AdapterList = AdapterList()
    /// Описание данных таблицы
    public var list: AdapterList { return _list }

    private var collectionViewDelegate: CollectionViewAdapterDelegate!

    private let batchUpdater = BatchUpdater()

    // MARK: - Callbacks
    /// Обработка методов таблицы
    public let callbacks: TableAdapterCallbacks = TableAdapterCallbacks()

    /// Обработка методов scrollView
    public let scrollViewCallbacks: AdapterScrollViewCallbacks = AdapterScrollViewCallbacks()

    // MARK: - Dependencies
    public var collectionView: UICollectionView

    // MARK: - LifeCycle
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView

        self.collectionViewDelegate = CollectionViewAdapterDelegate(holder: self)
        self.collectionView.delegate = collectionViewDelegate
        self.collectionView.dataSource = collectionViewDelegate
    }

    // MARK: - Private
    fileprivate func registerCells() {
        for section in list.sections {
            for row in section.rows {
                collectionView.register(row.cellType, forCellWithReuseIdentifier: row.reuseId)
            }
        }
    }

    // MARK: - Reload
    public func reload(with tableList: AdapterList? = nil) {
        let oldList = self._list

        if let list = tableList {
            self._list = list
        } else {
            self._list = AdapterList()
        }
        registerCells()

        if oldList.sections.isEmpty || _list.sections.isEmpty {
            collectionView.reloadData()
            return
        }

        batchUpdater.batchUpdate(collectionView: collectionView,
                                 oldSections: oldList.sections,
                                 newSections: list.sections,
                                 completion: nil)
    }
}
