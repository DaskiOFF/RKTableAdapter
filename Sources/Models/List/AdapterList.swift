import Foundation

public typealias TableList = AdapterList<TableSection>
public typealias CollectionList = AdapterList<CollectionSection>

/// Модель описывающая данные списка для TableViewAdapter и CollectionViewAdapter
open class AdapterList<SectionType: SectionUniqIdentifier> {
    // MARK: - Properties
    /// Список секций
    public var sections: [SectionType] = []
    
    // MARK: - Init
    public init() { }
    
    
    // MARK: - Subscript
    /// Найдет или создаст и вернет секцию с указаным идентификатором
    ///
    /// - Parameter id: Идентификатор секции
    public subscript(id: Int) -> SectionType {
        get {
            return self["\(id)"]
        }
    }

    /// Найдет или создаст и вернет секцию с указаным идентификатором
    ///
    /// - Parameter id: Идентификатор секции
    public subscript(id: String) -> SectionType {
        get {
            for section in sections where section.id == id {
                return section
            }
            
            return makeNewSection(with: id)
        }
    }
    
    // MARK: - Private
    private func makeNewSection(with id: String) -> SectionType {
        let newSection = SectionType(with: id)
        sections.append(newSection)
        return newSection
    }
}
