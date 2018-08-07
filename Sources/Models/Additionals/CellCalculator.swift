//
//  CellCalculator.swift
//  RKTableAdapter
//
//  Created by Roman Kotov on 07/08/2018.
//  Copyright © 2018 Roman Kotov. All rights reserved.
//

import UIKit

class CellCalculator<LayoutType, ViewModelType> {
    // MARK: - Properties
    private var cache: [CGFloat: LayoutType] = [:]

    @discardableResult
    func layout(with viewModel: ViewModelType, width: CGFloat) -> LayoutType {
        if let layout = cache[width] {
            return layout
        }

        let layout = calculate(with: viewModel, width: width)
        cache[width] = layout
        return layout
    }

    @discardableResult
    func calculate(with viewModel: ViewModelType, width: CGFloat) -> LayoutType {
        preconditionFailure("This method must be overridden")
    }
}
