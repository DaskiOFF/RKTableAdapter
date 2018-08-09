import Foundation
import RKTableAdapter

class JustCollectionCellVM: CellVM, Equatable {
    // MARK: - Properties
    var title: String = ""

    // MARK: - Init
    init(title: String) {
        self.title = title
        super.init(action: nil, userInfo: nil)
    }

    // MARK: - RowHeightComputable
    override var defaultHeight: CGFloat? {
        return 44
    }

    // MARK: - Equatable
    static func == (lhs: JustCollectionCellVM, rhs: JustCollectionCellVM) -> Bool {
        guard lhs.title == rhs.title else { return false }
        return true
    }
}
