import Foundation

@available(*, deprecated, renamed: "TableCellVM")
public typealias CellVM = TableCellVM

/// Родительский класс для любой ViewModel ячейки
open class SuperCellVM {
    // MARK: Types
    public typealias UserInfoType = Any

    /// Тип замыкания действия при нажатии на ячейку
    public typealias ActionType = (UserInfoType?) -> Void

    // MARK: Properties
    /// Автоматически снимать выделение
    public var deselectAutomatically: Bool = true

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
}
