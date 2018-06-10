import UIKit

open class TableRow<CellType: ConfigurableCell>: RowConfigurable where CellType: UITableViewCell {
    // MARK: - Properties
    /// Идентификатор строки
    public let id: String
    /// Модель данных
    public let viewModel: CellType.ViewModelType
    /// Модель данных (Для внутреннего использования)
    /// :nodoc:
    public var cellVM: CellVM {
        return viewModel
    }
    
    // MARK: - Init
    public init(viewModel: CellType.ViewModelType) {
        self.id = "\(Date().timeIntervalSince1970)"
        self.viewModel = viewModel
    }
    
    public init(id: Int, viewModel: CellType.ViewModelType) {
        self.id = "\(id)"
        self.viewModel = viewModel
    }
    
    public init(id: String, viewModel: CellType.ViewModelType) {
        self.id = id
        self.viewModel = viewModel
    }
    
    // MARK: - RowConfigurable
    /// Конфигурация ячейки
    ///
    /// - Parameter cell: Ячейка, которую необходимо сконфигурировать
    public func configure(_ cell: UITableViewCell) {
        if let configurableCell = cell as? CellType {
            configurableCell.configure(with: viewModel)
        }
    }

    /// :nodoc:
    public var reuseId: String {
        return CellType.reuseId
    }

    /// :nodoc:
    public var cellType: AnyClass {
        return CellType.self
    }

    /// :nodoc:
    public var estimatedHeight: CGFloat? {
        return viewModel.estimatedHeight
    }

    /// :nodoc:
    public var defaultHeight: CGFloat? {
        return viewModel.defaultHeight
    }
    
    // MARK: - Equatable
    /// :nodoc:
    public static func == (lhs: TableRow<CellType>, rhs: TableRow<CellType>) -> Bool {
        return lhs.viewModel == rhs.viewModel
    }
}
