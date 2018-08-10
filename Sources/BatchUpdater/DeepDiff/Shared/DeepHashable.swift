//
//  DeepHashable.swift
//  DeepDiff-iOS
//
//  Created by Roman Kotov on 10/07/2018.
//  Copyright © 2018 Khoa Pham. All rights reserved.
//

import Foundation

public protocol DeepEquatable {
    func equal(object: Any?) -> Bool
}

public protocol DeepHashable: DeepEquatable {
    var deepDiffHash: Int { get }
}

extension DeepHashable where Self: Hashable {
    public var deepDiffHash: Int {
        return self.hashValue
    }

//    public func equal(object: Any?) -> Bool {
//        guard let object = object as? Self else { return false }
//        return self == object
//    }
}

extension String: DeepHashable {
    public func equal(object: Any?) -> Bool {
        guard let object = object as? String else { return false }
        return self == object
    }
}

extension Character: DeepHashable {
    public func equal(object: Any?) -> Bool {
        guard let object = object as? Character else { return false }
        return self == object
    }
}

