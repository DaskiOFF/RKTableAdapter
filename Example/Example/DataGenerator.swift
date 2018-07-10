//
//  DataGenerator.swift
//  Example
//
//  Created by Roman Kotov on 10/07/2018.
//  Copyright © 2018 Roman Kotov. All rights reserved.
//

import Foundation
import RKTableAdapter

class DataGenerator {
    static func generateViewModels1() -> TableList {
        let list = TableList()

        for i in 0..<4 {
            let section = list[i]

            for j in 100..<105 {
                section.append(row: TableRow<JustCell>.init(id: j, viewModel: JustCellVM(title: "cell \(j) in section \(i)")))
            }
        }

        return list
    }

    static func generateViewModels2() -> TableList {
        let list = generateViewModels1()

        list.sections.remove(at: 1)

        return list
    }
}
