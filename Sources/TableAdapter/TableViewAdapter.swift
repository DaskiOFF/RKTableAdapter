import Foundation
import UIKit

open class TableViewAdapter {
    // MARK: - Properties
    private var _list: TableList = TableList()
    /// Описание данных таблицы
    public var list: TableList { return _list }

    private var tableViewDelegate: TableViewAdapterDelegate!

    private let batchUpdater = BatchUpdater()

    // MARK: - Callbacks
    /// Обработка методов таблицы
    public let callbacks: TableAdapterCallbacks = TableAdapterCallbacks()

    /// Обработка методов scrollView
    public let scrollViewCallbacks: AdapterScrollViewCallbacks = AdapterScrollViewCallbacks()
    
    // MARK: - Dependencies
    public var tableView: UITableView
    
    // MARK: - LifeCycle
    public init(tableView: UITableView) {
        self.tableView = tableView
        
        self.tableViewDelegate = TableViewAdapterDelegate(holder: self)
        self.tableView.delegate = tableViewDelegate
        self.tableView.dataSource = tableViewDelegate
    }

    // MARK: - Private
    fileprivate func registerCells(sections: [TableSection]) {
        for section in sections {
            for row in section.rows {
                tableView.register(row.cellType, forCellReuseIdentifier: row.reuseId)
            }
        }
    }

    // MARK: - Reload
    public func reload(with tableList: TableList? = nil) {
        registerCells(sections: tableList?.sections ?? [])

        let oldList = self._list

        if let list = tableList {
            self._list = list
        } else {
            self._list = AdapterList()
        }

        if oldList.sections.isEmpty || _list.sections.isEmpty {
            tableView.reloadData()
            return
        }

        batchUpdater.batchUpdate(tableView: tableView,
                                 oldSections: oldList.sections,
                                 newSections: list.sections,
                                 completion: nil)
    }
}
