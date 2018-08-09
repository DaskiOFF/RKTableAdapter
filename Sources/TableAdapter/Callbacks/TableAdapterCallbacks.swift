import UIKit

open class TableAdapterCallbacks {
    // MARK: - Types
    public typealias TableData = (section: AdapterSection, row: RowConfigurable)

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
    
    private(set) var canEditRow: CanEditRow?
    private(set) var editingStyleRow: EditingStyleRow?
    private(set) var commitEditRow: CommitEditRow?
    
    public func setCanEditRow(_ block: CanEditRow?) {
        canEditRow = block
    }
    public func setEditingStyleRow(_ block: EditingStyleRow?) {
        editingStyleRow = block
    }
    public func setCommitEditRow(_ block: CommitEditRow?) {
        commitEditRow = block
    }
    
    // MARK: - Header / Footer
    public typealias WillDisplayHeaderFooterView = (UITableView, UIView, AdapterSection, Int) -> Void
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
