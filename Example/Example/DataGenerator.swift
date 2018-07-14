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

        for i in 0..<3 {
            let section = list[i]
            section.headerString = "\(i)"

            for j in 0..<5 {
                section.append(row: TableRow<JustCell>.init(id: "\(j)_\(i)", viewModel: JustCellVM(title: "\(j) in \(i)")))
            }
        }

        return list
    }

    static func generateViewModels2() -> TableList {
        let list = generateViewModels1()

        list.sections.remove(at: 1)

//        do {
//            let r = list.sections[1].remove(rowAt: 1) // delete 1_2
//            list.sections[0].append(row: r) // insert 1_2 to after 4_0
//        }

        list.sections[0].remove(rowAt: 3) // delete 3_0
//        list.sections[1].remove(rowAt: 1) // delete 2_2

//        do {
//            let r = list.sections[1].remove(rowAt: 0) // delete 0_2
//            list.sections[1].append(row: r) // insert 0_2 to after 4_2
//        }

        let s = list.sections.remove(at: 0)
        s.headerString = "New"

        let i = 900
        let section = list[i]
        section.headerString = "\(i)"
        for j in 0..<2 {
            section.append(row: TableRow<JustCell>.init(id: "\(j)_\(i)", viewModel: JustCellVM(title: "\(j) in \(i)")))
        }

        let s1 = list.sections.removeLast()
        list.sections.insert(s1, at: 0)

        list.sections.append(s)

        return list
    }
}
