import UIKit

public extension UITableView {
    public func emptyFooter() {
        self.tableFooterView = UIView()
    }
    
    public func emptyHeader() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude)
        self.tableHeaderView = view
    }
}
