import UIKit

open class TableRow<CellType: ConfigurableCell>: RowConfigurable where CellType: UITableViewCell {
    // MARK: - Properties
    /// Модель данных
    public let viewModel: CellType.ViewModelType
    /// Модель данных (Для внутреннего использования)
    /// :nodoc:
    override var cellVM: CellVM {
        return viewModel
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

    /// :nodoc:
    public override var reuseId: String {
        return CellType.reuseId
    }

    /// :nodoc:
    public override var cellType: AnyClass {
        return CellType.self
    }

    /// :nodoc:
    public override var estimatedHeight: CGFloat? {
        return viewModel.estimatedHeight
    }

    /// :nodoc:
    public override  var defaultHeight: CGFloat? {
        return viewModel.defaultHeight
    }
    
    // MARK: - DeepHashable
    /// :nodoc:
    public override func equal(object: Any?) -> Bool {
        guard let object = object as? TableRow<CellType> else { return false }

        return self.viewModel == object.viewModel
    }
}
