//
//  DataGenerator.swift
//  TestBatchUpdate
//
//  Created by Roman Kotov on 12/07/2018.
//  Copyright © 2018 Roman Kotov. All rights reserved.
//

import Foundation
@testable import RKTableAdapter

class SectionRow: DeepHashable {
    var id: Int = 0
    var text: String = ""

    init(id: Int, text: String) {
        self.id = id
        self.text = text
    }

    var deepDiffHash: Int {
        return id
    }

    func equal(object: Any?) -> Bool {
        guard let object = object as? SectionRow else { return false }
        return self.text == object.text
    }
}

class Section: BatchUpdateSection {
    var id: String
    var headerString: String = ""
    var _rows: [SectionRow] = []

    init(id: String) {
        self.id = id
    }

    func getRows() -> [DeepHashable] {
        return self._rows
    }

    var deepDiffHash: Int {
        return id.hashValue
    }

    func equal(object: Any?) -> Bool {
        guard let object = object as? Section else { return false }
        return self.id == object.id && self.headerString == object.headerString
    }
}

class DataGenerator {
    static func generateViewModels1() -> [Section] {
        var list: [Section] = []
        
        do {
            let sectionId = "0"
            let section = Section(id: sectionId)
            section.headerString = sectionId
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 1, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "1"
            let section = Section(id: sectionId)
            section.headerString = sectionId
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 1, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "2"
            let section = Section(id: sectionId)
            section.headerString = "sectionId2"
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 1, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "4"
            let section = Section(id: sectionId)
            section.headerString = sectionId
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 1, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "3"
            let section = Section(id: sectionId)
            section.headerString = sectionId
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 1, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "5"
            let section = Section(id: sectionId)
            section.headerString = sectionId
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 3, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }

        return list
    }

    static func generateViewModels2() -> [Section] {
        var list: [Section] = []

        do {
            let sectionId = "900"
            let section = Section(id: sectionId)
            section.headerString = sectionId
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 0, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 0, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "0"
            let section = Section(id: sectionId)
            section.headerString = "sectionId"
            section._rows.append(SectionRow(id: 1, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            section._rows.append(SectionRow(id: 3, text: "row 3 in \(sectionId)"))
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "2"
            let section = Section(id: sectionId)
            section.headerString = sectionId
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 1, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "1"
            let section = Section(id: sectionId)
            section.headerString = "sectionId3"
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 1, text: "row 5 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "3"
            let section = Section(id: sectionId)
            section.headerString = sectionId
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 1, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "4"
            let section = Section(id: sectionId)
            section.headerString = sectionId
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 1, text: "row 4 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        do {
            let sectionId = "5"
            let section = Section(id: sectionId)
            section.headerString = sectionId
            section._rows.append(SectionRow(id: 3, text: "row 1 in \(sectionId)"))
            section._rows.append(SectionRow(id: 0, text: "row 0 in \(sectionId)"))
            section._rows.append(SectionRow(id: 2, text: "row 2 in \(sectionId)"))
            list.append(section)
        }
        
    
        return list
    }
}
