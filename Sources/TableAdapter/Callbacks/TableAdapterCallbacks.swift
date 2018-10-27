import UIKit

open class TableAdapterCallbacks {
    // MARK: - Types
    public typealias TableData = (section: TableSection, row: TableRowConfigurable)

    // MARK: - Props

    // MARK: - Edit
    #if swift(>=4.2)
    public typealias TableViewCellEditingStyle = UITableViewCell.EditingStyle
    #else
    public typealias TableViewCellEditingStyle = UITableViewCellEditingStyle
    #endif

    public typealias CanEditRow = (UITableView, IndexPath, TableData) -> Bool
    public typealias EditingStyleRow = (UITableView, IndexPath, TableData) -> TableViewCellEditingStyle
    public typealias CommitEditRow = (UITableView, IndexPath, TableViewCellEditingStyle, TableData) -> Void
    @available(iOS 11.0, *)
    public typealias TrailingSwipeActionsConfigurationForRow = (UITableView, IndexPath, TableData) -> UISwipeActionsConfiguration?

    private(set) var canEditRow: CanEditRow?
    private(set) var editingStyleRow: EditingStyleRow?
    private(set) var commitEditRow: CommitEditRow?
    /// type of TrailingSwipeActionsConfigurationForRow
    private(set) var trailingSwipeActionsConfigurationForRow: Any?

    public func setCanEditRow(_ block: CanEditRow?) {
        canEditRow = block
    }
    public func setEditingStyleRow(_ block: EditingStyleRow?) {
        editingStyleRow = block
    }
    public func setCommitEditRow(_ block: CommitEditRow?) {
        commitEditRow = block
    }
    @available(iOS 11.0, *)
    public func setTrailingSwipeActionsConfigurationForRow(_ block: TrailingSwipeActionsConfigurationForRow?) {
        trailingSwipeActionsConfigurationForRow = block
    }

    // MARK: - Select
    public typealias DidSelectRow = (UITableView, IndexPath, TableData) -> Void

    private(set) var didSelectRow: DidSelectRow?

    public func setDidSelectRow(_ block: DidSelectRow?) {
        didSelectRow = block
    }

    // MARK: - Cell
    public typealias WillDisplayCell = (UITableView, UITableViewCell, IndexPath, TableData) -> Void
    public typealias DidEndDisplayingCell = (UITableView, UITableViewCell, IndexPath, TableData) -> Void

    private(set) var willDisplayCell: WillDisplayCell?
    private(set) var didEndDisplayingCell: DidEndDisplayingCell?

    public func setWillDisplayCell(_ block: WillDisplayCell?) {
        willDisplayCell = block
    }

    public func setDidEndDisplayingCell(_ block: DidEndDisplayingCell?) {
        didEndDisplayingCell = block
    }

    // MARK: - Header / Footer
    public typealias WillDisplayHeaderFooterView = (UITableView, UIView, TableSection, Int) -> Void
    public typealias DidEndDisplayHeaderFooterView = WillDisplayHeaderFooterView

    private(set) var willDisplayHeaderView: WillDisplayHeaderFooterView?
    private(set) var willDisplayFooterView: WillDisplayHeaderFooterView?
    private(set) var didEndDisplayHeaderView: DidEndDisplayHeaderFooterView?
    private(set) var didEndDisplayFooterView: DidEndDisplayHeaderFooterView?

    public func setWillDisplayHeaderView(_ block: WillDisplayHeaderFooterView?) {
        willDisplayHeaderView = block
    }
    public func setWillDisplayFooterView(_ block: WillDisplayHeaderFooterView?) {
        willDisplayFooterView = block
    }
    public func setDidEndDisplayHeaderView(_ block: DidEndDisplayHeaderFooterView?) {
        didEndDisplayHeaderView = block
    }
    public func setDidEndDisplayFooterView(_ block: DidEndDisplayHeaderFooterView?) {
        didEndDisplayFooterView = block
    }
}
