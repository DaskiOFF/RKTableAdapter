import UIKit

/// Протокол описывающий поля для высоты ячейки
/// :nodoc:
public protocol RowHeightComputable: class {
    var estimatedHeight: CGFloat? { get }
    var defaultHeight: CGFloat? { get }
}

/// Родительский класс для любой ViewModel ячейки
open class CellVM: RowHeightComputable, Equatable {
    // MARK: Types
    public typealias UserInfoType = Any
    /// Тип замыкания действия при нажатии на ячейку
    public typealias ActionType = (UserInfoType?) -> Void
    
    // MARK: Properties
    /// Автоматически снимать выделение
    public var deselectAutomatically: Bool = true
    /// Выделяемая ячейка или нет
    public var isSelectable: Bool = true
    public var accessoryType: UITableViewCellAccessoryType = .none

    // MARK: DidSelectAction and data
    /// Действие, которое вызывается при нажатии на ячейку
    public var action: ActionType?
    /// Данные, которые передаются в замыкание действия, если эти данные nil, то в замыкание будет передана viewModel (self)
    public var userInfo: UserInfoType?
    
    // MARK: Init
    public init(action: ActionType?, userInfo: UserInfoType?) {
        self.action = action
        self.userInfo = userInfo
    }
    
    // MARK: RowHeightComputable
    open var estimatedHeight: CGFloat? { return nil }
    open var defaultHeight: CGFloat? { return nil }
    
    // MARK: Bind / Unbind
    private(set) public weak var view: ConfigureCell?
    func bind(view: BindingCell & ConfigureCell) {
        if self.view != nil {
            unbind()
        }
        view.bind(viewModel: self)
        self.view = view
    }
    
    func unbind() {
        if let bindingCell = self.view as? BindingCell {
            bindingCell.unbind()
        }
        self.view = nil
    }
    
    // MARK: Equatable
    /// :nodoc:
    public static func == (lhs: CellVM, rhs: CellVM) -> Bool {
        preconditionFailure("This method must be overridden")
    }
}

/// :nodoc:
public protocol RowConfigurable: RowHeightComputable {
    // MARK: Properties
    /// Идентификатор строки
    var id: String { get }
    /// Идентификатор для повторного использования ячейки
    var reuseId: String { get }
    /// Тип ячейки
    var cellType: AnyClass { get }
    /// Модель данных ячейки
    var cellVM: CellVM { get }
    
    // MARK: Configure
    /// Метод конфигурации ячейки с помощью viewModel
    ///
    /// - Parameter cell: Ячейка, которую необходимо сконфигурировать
    func configure(_ cell: UITableViewCell)
}
