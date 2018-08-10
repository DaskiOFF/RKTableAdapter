import UIKit

class TableViewAdapterDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Types
    #if swift(>=4.2)
    public let TableViewAutomaticDimension = UITableView.automaticDimension
    public typealias TableViewCellEditingStyle = UITableViewCell.EditingStyle
    #else
    public let TableViewAutomaticDimension = UITableViewAutomaticDimension
    public typealias TableViewCellEditingStyle = UITableViewCellEditingStyle
    #endif

    // MARK: - Properties
    unowned var holder: TableViewAdapter
    var automaticHeaderFooterHeight: CGFloat = 0

    // MARK: - Init
    init(holder: TableViewAdapter) {
        self.holder = holder
        if holder.tableView.style == .grouped {
            self.automaticHeaderFooterHeight = TableViewAutomaticDimension
        }
    }

    // MARK: - getters
    private func section(for index: Int) -> TableSection? {
        guard index < holder.list.sections.count else { return nil }
        return holder.list.sections[index]
    }

    private func row(for section: TableSection, index: Int) -> TableRowConfigurable? {
        guard index < section.numberOfRows else { return nil }
        return section.rows[index]
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource
    // MARK: Size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = holder.list.sections[indexPath.section].rows[indexPath.row]
        return row.cellVM.defaultHeight ??
            row.cellVM.estimatedHeight ??
        TableViewAutomaticDimension
    }

    // MARK: Selecting
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
            else { return }

        if row.cellVM.deselectAutomatically {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        row.cellVM.action?(row.cellVM.userInfo ?? row.cellVM)
    }

    // MARK: Number sections, items
    func numberOfSections(in tableView: UITableView) -> Int {
        return holder.list.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holder.list.sections[section].numberOfRows
    }

    // MARK: Cell
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

    func tableView(_ tableView: UITableView, commit editingStyle: TableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let section = section(for: indexPath.section),
            let row = row(for: section, index: indexPath.row)
            else { return }
        holder.callbacks.commitEditRow?(tableView, indexPath, editingStyle, (section, row))
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> TableViewCellEditingStyle {
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
        guard let AdapterSection = self.section(for: section) else { return }
        holder.callbacks.willDisplayHeaderView?(tableView, view, AdapterSection, section)
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        guard let AdapterSection = self.section(for: section) else { return }
        holder.callbacks.didEndDisplayHeaderView?(tableView, view, AdapterSection, section)
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
        guard let AdapterSection = self.section(for: section) else { return }
        holder.callbacks.willDisplayFooterView?(tableView, view, AdapterSection, section)
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        guard let AdapterSection = self.section(for: section) else { return }
        holder.callbacks.didEndDisplayFooterView?(tableView, view, AdapterSection, section)
    }

    // MARK: - ScroolViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        holder.scrollViewCallbacks.scrollViewDidScroll?(scrollView)
    }
}
