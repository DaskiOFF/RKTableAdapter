import Foundation

public typealias TableList = AdapterList
public typealias CollectionList = AdapterList

/// Модель описывающая данные для таблицы
open class AdapterList {
    // MARK: - Properties
    /// Список секций
    public var sections: [AdapterSection] = []
    
    // MARK: - Init
    public init() { }
    
    
    // MARK: - Subscript
    /// Найдет или создаст и вернет секцию с указаным идентификатором
    ///
    /// - Parameter id: Идентификатор секции
    public subscript(id: Int) -> AdapterSection {
        get {
            return self["\(id)"]
        }
    }


    /// Найдет или создаст и вернет секцию с указаным идентификатором
    ///
    /// - Parameter id: Идентификатор секции
    public subscript(id: String) -> AdapterSection {
        get {
            for section in sections where section.id == id {
                return section
            }
            
            return makeNewSection(with: id)
        }
    }
    
    // MARK: - Private
    private func makeNewSection(with id: String) -> AdapterSection {
        let newSection = AdapterSection(with: id)
        sections.append(newSection)
        return newSection
    }
}
