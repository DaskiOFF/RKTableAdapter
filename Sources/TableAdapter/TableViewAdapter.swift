import Foundation
import UIKit

/// Для работы с TableViewAdapter
/// - Ячейка должна реализовывать протокол ConfigurableCell
/// - ViewModel ячейки должна наследоваться от CellVM
///
/// - Необходимо его создать используя UITableView
///
///         let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
///         lazy var tableAdapter = TableViewAdapter(tableView: self.tableView)
///
/// - Создать контент для таблицы
///
///         private func configureTableAdapterContent() {
///             let tableList = TableList()
///
///             makeMySection(tableList)
///
///             tableAdapter.reload(with: tableList)
///         }
///
///         private func makeMySection(_ list: TableList) {
///             let section = list["mySection"]
///             section.headerHeight = 30
///             section.footerHeight = 40
///
///             do {
///                 let viewModel = TableSwitchCellVM(title: "Автосохранение", isOn: true)
///                 vmAutosave.changeAction = autosaveStateChanged
///
///                 let switchRow = TableRowSwitch(viewModel: vmAutosave)
///                 section.append(row: switchRow)
///             }
///
///             do {
///                 let vm = MenuItemCellVM(title: "Поделиться", action: share)
///                 section.append(row: TableRow<MenuItemCell>(id: "share", viewModel: vm))
///             }
///         }
///
/// - Описать замыкания для действий
///
///         private lazy var share: CellVM.ActionType = { [weak self] _ in
///             guard let sself = self else { return }
///
///             // do sth...
///         }
///
/// - Если необходимо настроить обработку callbacks, то это делаем в методе
///
///         private func setupTableAdapter() {
///             // tableAdapter.callbacks...
///             // tableAdapter.scrollViewCallbacks...
///         }
///     который вызываем из viewDidLoad
///
///
/// - Для перезагрузки таблицы
///
///         tableAdapter.reload(with: tableList)
open class TableViewAdapter {

    // MARK: - Properties
    private var _list: AdapterList = AdapterList()
    /// Описание данных таблицы
    public var list: AdapterList { return _list }

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
    fileprivate func registerCells() {
        for section in list.sections {
            for row in section.rows {
                tableView.register(row.cellType, forCellReuseIdentifier: row.reuseId)
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
            tableView.reloadData()
            return
        }

        batchUpdater.batchUpdate(tableView: tableView,
                                 oldSections: oldList.sections,
                                 newSections: list.sections,
                                 completion: nil)
    }
}
