import UIKit

open class TableSection: AdapterSection<TableRowConfigurable> {
    // MARK: Header / Footer
    /// Заголовок хедера секции (Внимание! Возможно установить или headerString, или headerView)
    /// Приоритет имеет headerView
    public var headerString: String?
    /// Высота хедера
    public var headerHeight: CGFloat?
    /// CustomView для хедера секции (Внимание! Возможно установить или headerString, или headerView)
    /// Приоритет имеет headerView
    public var headerView: UIView?

    /// Заголовок футера секции (Внимание! Возможно установить или footerString, или footerView)
    /// Приоритет имеет footerView
    public var footerString: String?
    /// Высота футера
    public var footerHeight: CGFloat?
    /// CustomView для футера секции (Внимание! Возможно установить или footerString, или footerView)
    /// Приоритет имеет footerView
    public var footerView: UIView?

    public static func == (lhs: TableSection, rhs: TableSection) -> Bool {
        guard lhs.id == rhs.id else { return false }
        guard lhs.headerString == rhs.headerString else { return false }
        guard lhs.headerHeight == rhs.headerHeight else { return false }
        guard lhs.headerView == rhs.headerView else { return false }
        guard lhs.footerString == rhs.footerString else { return false }
        guard lhs.footerHeight == rhs.footerHeight else { return false }
        guard lhs.footerView == rhs.footerView else { return false }
        return true
    }

    public override func equal(object: Any?) -> Bool {
        guard let object = object as? TableSection else { return false }
        return self == object
    }
}
