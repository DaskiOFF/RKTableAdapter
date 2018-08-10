import UIKit

/// :nodoc:
public protocol UniqIdentifier {
    var id: String { get }
}

/// :nodoc:
public protocol SectionUniqIdentifier: UniqIdentifier {
    init(with id: String)
}
