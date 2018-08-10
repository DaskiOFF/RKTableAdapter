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

        list.sections[0].remove(rowAt: 3) // delete 3_0

        let s = list.sections.remove(at: 0)
//        s.headerString = "New"

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

    static func generateCollectionViewModels1() -> CollectionList {
        let list = CollectionList()

        for i in 0..<3 {
            let section = list[i]

            for j in 0..<5 {
                section.append(row: CollectionItem<JustCollectionCell>.init(id: "\(j)_\(i)", viewModel: JustCollectionCellVM(title: "\(j) in \(i)")))
            }
        }

        return list
    }

    static func generateCollectionViewModels2() -> CollectionList {
        let list = generateCollectionViewModels1()

        list.sections.remove(at: 1)

        list.sections[0].remove(rowAt: 3) // delete 3_0

        let s = list.sections.remove(at: 0)

        let i = 900
        let section = list[i]
        for j in 0..<2 {
            section.append(row: CollectionItem<JustCollectionCell>.init(id: "\(j)_\(i)", viewModel: JustCollectionCellVM(title: "\(j) in \(i)")))
        }

        let s1 = list.sections.removeLast()
        list.sections.insert(s1, at: 0)

        list.sections.append(s)

        return list
    }
}
