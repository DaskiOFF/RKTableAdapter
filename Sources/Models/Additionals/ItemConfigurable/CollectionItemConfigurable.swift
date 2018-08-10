import UIKit

open class CollectionItemConfigurable: ItemConfigurable {

    /// Модель данных ячейки
    var cellVM: CollectionCellVM {
        preconditionFailure("This method must be overridden")
    }
}
