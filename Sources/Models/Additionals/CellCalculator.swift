import UIKit

open class CellCalculator<LayoutType, ViewModelType> {
    // MARK: - Properties
    private var cache: [CGFloat: LayoutType] = [:]

    public init() {}

    @discardableResult
    public func layout(with viewModel: ViewModelType, width: CGFloat) -> LayoutType {
        if let layout = cache[width] {
            return layout
        }

        let layout = calculate(with: viewModel, width: width)
        cache[width] = layout
        return layout
    }

    @discardableResult
    open func calculate(with viewModel: ViewModelType, width: CGFloat) -> LayoutType {
        preconditionFailure("This method must be overridden")
    }
}
