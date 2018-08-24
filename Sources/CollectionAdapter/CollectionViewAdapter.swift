import Foundation
import UIKit

open class CollectionViewAdapter {

    // MARK: - Properties
    private let updQueue = DispatchQueue(label: "com.RKTableAdapter.collectionViewAdapter")
    let semaphore = DispatchSemaphore(value: 1)
    private var _list: AdapterList = CollectionList()
    /// Описание данных таблицы
    public var list: CollectionList { return _list }

    private var collectionViewDelegate: CollectionViewAdapterDelegate!

    private let batchUpdater = BatchUpdater()

    // MARK: - Callbacks
    /// Обработка методов таблицы
    public let callbacks: CollectionAdapterCallbacks = CollectionAdapterCallbacks()

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
    fileprivate func registerCells(sections: [CollectionSection]) {
        for section in sections {
            for row in section.rows {
                collectionView.register(row.cellType, forCellWithReuseIdentifier: row.reuseId)
            }
        }
    }

    // MARK: - Reload
    public func reload(with collectionList: CollectionList? = nil) {
        registerCells(sections: collectionList?.sections ?? [])

        updQueue.async { [weak self] in
            guard let sself = self else { return }
            _ = sself.semaphore.wait(timeout: .distantFuture)

            let oldList = sself._list

            if let list = collectionList {
                sself._list = list
            } else {
                sself._list = AdapterList()
            }

            DispatchQueue.main.async { [weak self] in
                guard let sself = self else { return }

                if oldList.sections.isEmpty || sself._list.sections.isEmpty {
                    sself.collectionView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                        guard let sself = self else { return }
                        sself.semaphore.signal()
                    })
                } else {
                    sself.batchUpdater.batchUpdate(collectionView: sself.collectionView,
                                                   oldSections: oldList.sections,
                                                   newSections: sself.list.sections,
                                                   completion: { [weak self] _ in
                                                    guard let sself = self else { return }
                                                    sself.semaphore.signal()
                    })
                }
            }
        }
    }
}
