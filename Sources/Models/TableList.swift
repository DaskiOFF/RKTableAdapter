import Foundation

/// Модель описывающая данные для таблицы
open class TableList {
    // MARK: - Properties
    /// Список секций
    public var sections: [TableSection] = []
    
    // MARK: - Init
    public init() { }
    
    
    // MARK: - Subscript
    /// Найдет или создаст и вернет секцию с указаным идентификатором
    ///
    /// - Parameter id: Идентификатор секции
    public subscript(id: Int) -> TableSection {
        get {
            return self["\(id)"]
        }
    }


    /// Найдет или создаст и вернет секцию с указаным идентификатором
    ///
    /// - Parameter id: Идентификатор секции
    public subscript(id: String) -> TableSection {
        get {
            for section in sections where section.id == id {
                return section
            }
            
            return makeNewSection(with: id)
        }
    }
    
    // MARK: - Private
    private func makeNewSection(with id: String) -> TableSection {
        let newSection = TableSection(with: id)
        sections.append(newSection)
        return newSection
    }
}
