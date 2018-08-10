import Foundation
import RKTableAdapter

class JustCollectionCellVM: CollectionCellVM, Equatable {
    // MARK: - Properties
    var title: String = ""

    // MARK: - Init
    init(title: String) {
        self.title = title
        super.init(action: nil, userInfo: nil)
    }

    // MARK: - CollectionItemSizeComputable
    override var defaultSize: CGSize? {
        return CGSize(width: 50, height: 50)
    }

    // MARK: - Equatable
    static func == (lhs: JustCollectionCellVM, rhs: JustCollectionCellVM) -> Bool {
        guard lhs.title == rhs.title else { return false }
        return true
    }
}
