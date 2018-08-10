import UIKit

/// :nodoc:
public protocol CollectionItemSizeComputable: class {
    var estimatedSize: CGSize? { get }
    var defaultSize: CGSize? { get }
}

/// :nodoc:
public extension CollectionItemSizeComputable {
    var estimatedSize: CGSize? { return nil }
    var defaultSize: CGSize? { return nil }
}

open class CollectionCellVM: SuperCellVM,
CollectionItemSizeComputable {
    // MARK: - CollectionItemSizeComputable
    open var estimatedSize: CGSize? {
        return nil
    }

    open var defaultSize: CGSize? {
        return nil
    }
}
