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
    private var _list: TableList = TableList()
    /// Описание данных таблицы
    public var list: TableList { return _list }

    private var tableViewDelegate: TableViewAdapterDelegate!

    // MARK: - Callbacks
    /// Обработка методов таблицы
    public let callbacks: TableAdapterCallbacks = TableAdapterCallbacks()

    /// Обработка методов scrollView
    public let scrollViewCallbacks: TableAdapterScrollViewCallbacks = TableAdapterScrollViewCallbacks()
    
    // MARK: - Dependencies
    public var tableView: UITableView
    
    // MARK: - LifeCycle
    public init(tableView: UITableView) {
        self.tableView = tableView
        
        self.tableViewDelegate = TableViewAdapterDelegate(holder: self)
        self.tableView.delegate = tableViewDelegate
        self.tableView.dataSource = tableViewDelegate
    }
    
    // MARK: - Reload
    public func reload(with tableList: TableList? = nil) {
        if let list = tableList {
            self._list = list
        }
        
        registerCells()
        tableView.reloadData()
    }
    
    // MARK: - Private
    fileprivate func registerCells() {
        for section in list.sections {
            for row in section.rows {
                tableView.register(row.cellType, forCellReuseIdentifier: row.reuseId)
            }
        }
    }
}

class TableViewAdapterDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    unowned var holder: TableViewAdapter
    var automaticHeaderFooterHeight: CGFloat = 0
    
    // MARK: - Init
    init(holder: TableViewAdapter) {
        self.holder = holder
        if holder.tableView.style == .grouped {
            self.automaticHeaderFooterHeight = UITableViewAutomaticDimension
        }
    }
    
    // MARK: - getters
    private func section(for index: Int) -> TableSection? {
        guard index < holder.list.sections.count else { return nil }
        return holder.list.sections[index]
    }
    
    private func row(for section: TableSection, index: Int) -> RowConfigurable? {
        guard index < section.rows.count else { return nil }
        return section.rows[index]
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = holder.list.sections[indexPath.section].rows[indexPath.row]
        return row.defaultHeight ??
            row.estimatedHeight ??
        UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
            else { return }
        
        if row.cellVM.deselectAutomatically {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        row.cellVM.action?(row.cellVM.userInfo ?? row.cellVM)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return holder.list.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holder.list.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = section(for: indexPath.section)?.rows[indexPath.row] else { fatalError() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseId) else { fatalError() }
        
        cell.selectionStyle = row.cellVM.isSelectable ? .default : .none
        row.configure(cell)
        if let bindingCell = cell as? BindingCell & ConfigureCell {
            row.cellVM.bind(view: bindingCell)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let row = section(for: indexPath.section)?.rows[indexPath.row] else { return }
        
        if let bindingCell = cell as? BindingCell & ConfigureCell {
            row.cellVM.bind(view: bindingCell)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let bindingCell = cell as? BindingCell {
            bindingCell.unbind()   
        }
    }
    
    // MARK: Edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
            else { return false }
        return holder.callbacks.canEditRow?(tableView, indexPath, (section, row)) ?? false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
            else { return }
        holder.callbacks.commitEditRow?(tableView, indexPath, editingStyle, (section, row))
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
            else { return .none }
        return holder.callbacks.editingStyleRow?(tableView, indexPath, (section, row)) ?? .none
    }
    
    // MARK: Header / Footer
    // Header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = self.section(for: section), section.headerView == nil else { return nil }
        return section.headerString
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = self.section(for: section) else { return nil }
        return section.headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = self.section(for: section) else {
            return automaticHeaderFooterHeight
        }
        return section.headerHeight ?? automaticHeaderFooterHeight
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let tableSection = self.section(for: section) else { return }
        holder.callbacks.willDisplayHeaderView?(tableView, view, tableSection, section)
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard let tableSection = self.section(for: section) else { return }
        holder.callbacks.didEndDisplayHeaderView?(tableView, view, tableSection, section)
    }
    
    // Footer
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = self.section(for: section), section.footerView == nil else { return nil }
        return section.footerString
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let section = self.section(for: section) else { return nil }
        return section.footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let section = self.section(for: section) else { return automaticHeaderFooterHeight }
        return section.footerHeight ?? automaticHeaderFooterHeight
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let tableSection = self.section(for: section) else { return }
        holder.callbacks.willDisplayFooterView?(tableView, view, tableSection, section)
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        guard let tableSection = self.section(for: section) else { return }
        holder.callbacks.didEndDisplayFooterView?(tableView, view, tableSection, section)
    }
    
    // MARK: - ScroolViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        holder.scrollViewCallbacks.scrollViewDidScroll?(scrollView)
    }
}
