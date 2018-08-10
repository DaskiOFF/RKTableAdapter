import UIKit

open class TableRowConfigurable: ItemConfigurable {
    /// Модель данных ячейки
    var cellVM: TableCellVM {
        preconditionFailure("This method must be overridden")
    }
}
