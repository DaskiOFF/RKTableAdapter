import Foundation

open class TableAdapterScrollViewCallbacks {
    // MARK: - Types
    
    // MARK: - Props
    
    // MARK: - ScrollView Delegate
    public typealias ScrollViewDidScroll = (_ scrollView: UIScrollView) -> Void
    
    private(set) var scrollViewDidScroll: ScrollViewDidScroll?
    
    public func setScrollViewDidScroll(_ block: ScrollViewDidScroll?) {
        scrollViewDidScroll = block
    }
}
