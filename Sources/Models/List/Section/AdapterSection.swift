import UIKit

open class AdapterSection<ItemType: DeepHashable & UniqIdentifier>:
    BatchUpdateSection,
    Hashable,
SectionUniqIdentifier {
    
    // MARK: - Properties
    /// Идентификатор
    public let id: String
    public private(set) var rows: [ItemType] = []

    // MARK: - Init
    public required init(with id: String) {
        self.id = id
    }
    
    // MARK: - Count
    /// Пустая ли секция
    public var isEmpty: Bool {
        return rows.isEmpty
    }
    
    /// Количество элементов в секции
    public var numberOfRows: Int {
        return rows.count
    }
    
    // MARK: - Update list rows
    /// Добавить строку в секцию
    ///
    /// - Parameter row: Добавляемая строка
    public func append(row: ItemType) {
        rows.append(row)
    }
    
    /// Добавить строки в секцию
    ///
    /// - Parameter rows: Добавляемые строки
    public func append(rows: [ItemType]) {
        self.rows.append(contentsOf: rows)
    }
    
    /// Вставка строки в секцию
    ///
    /// - Parameters:
    ///   - row: Вставляемая строка
    ///   - index: Индекс вставки
    public func insert(row: ItemType, at index: Int) {
        rows.insert(row, at: index)
    }
    
    /// Вставка строк в секцию
    ///
    /// - Parameters:
    ///   - rows: Вставляемые строки
    ///   - index: Начиная с какого индекса вставлять
    public func insert(rows: [ItemType], at index: Int) {
        self.rows.insert(contentsOf: rows, at: index)
    }
    
    /// Удалить строку по индексу
    ///
    /// - Parameter index: Индекс удаляемой строки
    /// - Returns: Удаленная строка
    @discardableResult
    public func remove(rowAt index: Int) -> ItemType {
        return rows.remove(at: index)
    }
    
    /// Очистить список строк
    public func clear() {
        rows = []
    }
    
    // MARK: - Subscript
    /// Найдет и вернет строку с переданным id или nil иначе
    ///
    /// - Parameter id: Идентификатор строки
    public subscript(id: Int) -> ItemType? {
        get {
            return self["\(id)"]
        }
    }

    /// Найдет и вернет строку с переданным id или nil иначе
    ///
    /// - Parameter id: Идентификатор строки
    public subscript(id: String) -> ItemType? {
        get {
            for row in rows where row.id == id {
                return row
            }
            
            return nil
        }
    }

    // MARK: - Hashable
    public var hashValue: Int {
        return id.hashValue
    }

    public static func == (lhs: AdapterSection, rhs: AdapterSection) -> Bool {
        guard lhs.id == rhs.id else { return false }
        return true
    }

    public func equal(object: Any?) -> Bool {
        guard let object = object as? AdapterSection else { return false }
        return self == object
    }

    // MARK: - BatchUpdateSection
    func getRows() -> [DeepHashable] {
        return rows
    }
}
