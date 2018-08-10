import UIKit

open class CollectionItem<CellType: ConfigurableCell>: CollectionItemConfigurable {
    // MARK: - Properties
    /// Модель данных
    public private(set) var viewModel: CellType.ViewModelType

    override var cellVM: CollectionCellVM {
        return viewModel as! CollectionCellVM
    }

    // MARK: - Init
    public init(viewModel: CellType.ViewModelType) {
        self.viewModel = viewModel
        super.init()
        self.id = "\(Date().timeIntervalSince1970)"
    }

    public init(id: Int, viewModel: CellType.ViewModelType) {
        self.viewModel = viewModel
        super.init()
        self.id = "\(id)"
    }

    public init(id: String, viewModel: CellType.ViewModelType) {
        self.viewModel = viewModel
        super.init()
        self.id = id
    }

    // MARK: - RowConfigurable
    /// Конфигурация ячейки
    ///
    /// - Parameter cell: Ячейка, которую необходимо сконфигурировать
    public override func configure(_ cell: UITableViewCell) {
        if let configurableCell = cell as? CellType {
            configurableCell.configure(with: viewModel)
        }
    }

    public override func configure(collectionCell: UICollectionViewCell) {
        if let configurableCell = collectionCell as? CellType {
            configurableCell.configure(with: viewModel)
        }
    }

    /// :nodoc:
    public override var reuseId: String {
        return CellType.reuseId
    }

    /// :nodoc:
    public override var cellType: AnyClass {
        return CellType.self
    }

    // MARK: - DeepHashable
    /// :nodoc:
    public override func equal(object: Any?) -> Bool {
        guard let object = object as? CollectionItem<CellType> else { return false }

        return self.viewModel == object.viewModel
    }
}
