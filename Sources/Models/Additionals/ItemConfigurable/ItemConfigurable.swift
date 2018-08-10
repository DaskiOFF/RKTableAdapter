import UIKit

@available(*, deprecated, renamed: "TableRowConfigurable")
typealias RowConfigurable = TableRowConfigurable

/// :nodoc:
open class ItemConfigurable: DeepHashable, UniqIdentifier {
    // MARK: Properties
    /// Идентификатор строки
    public internal(set) var id: String = ""
    /// Идентификатор для повторного использования ячейки
    var reuseId: String {
        preconditionFailure("This method must be overridden")
    }
    /// Тип ячейки
    var cellType: AnyClass {
        preconditionFailure("This method must be overridden")
    }

    // MARK: Configure
    /// Метод конфигурации ячейки TableView с помощью viewModel
    ///
    /// - Parameter cell: Ячейка, которую необходимо сконфигурировать
    func configure(_ cell: UITableViewCell) {
        preconditionFailure("This method must be overridden")
    }

    /// Метод конфигурации ячейки CollectionView с помощью viewModel
    ///
    /// - Parameter collectionCell: Ячейка, которую необходимо сконфигурировать
    func configure(collectionCell: UICollectionViewCell) {
        preconditionFailure("This method must be overridden")
    }

    // MARK: DeepHashable
    public var deepDiffHash: Int {
        return self.id.hashValue
    }

    public func equal(object: Any?) -> Bool {
        preconditionFailure("This method must be overridden")
    }
}
