import Foundation

public typealias TableSection = AdapterSection
public typealias CollectionSection = AdapterSection

open class AdapterSection: BatchUpdateSection, Hashable  {
    // MARK: - Properties
    /// Идентификатор
    public let id: String
    public private(set) var rows: [RowConfigurable] = []
    
    // MARK: Header / Footer
    /// Заголовок хедера секции (Внимание! Возможно установить или headerString, или headerView)
    /// Приоритет имеет headerView
    public var headerString: String?
    /// Высота хедера
    public var headerHeight: CGFloat?
    /// CustomView для хедера секции (Внимание! Возможно установить или headerString, или headerView)
    /// Приоритет имеет headerView
    public var headerView: UIView?
    
    /// Заголовок футера секции (Внимание! Возможно установить или footerString, или footerView)
    /// Приоритет имеет footerView
    public var footerString: String?
    /// Высота футера
    public var footerHeight: CGFloat?
    /// CustomView для футера секции (Внимание! Возможно установить или footerString, или footerView)
    /// Приоритет имеет footerView
    public var footerView: UIView?

    // MARK: - Init
    public init(with id: String) {
        self.id = id
    }
    
    // MARK: - Count
    /// Пустая ли секция
    public var isEmpty: Bool {
        return rows.isEmpty
    }
    
    /// Количество строк в секции
    public var numberOfRows: Int {
        return rows.count
    }
    
    // MARK: - Update list rows
    /// Добавить строку в секцию
    ///
    /// - Parameter row: Добавляемая строка
    public func append(row: RowConfigurable) {
        rows.append(row)
    }
    
    /// Добавить строки в секцию
    ///
    /// - Parameter rows: Добавляемые строки
    public func append(rows: [RowConfigurable]) {
        self.rows.append(contentsOf: rows)
    }
    
    /// Вставка строки в секцию
    ///
    /// - Parameters:
    ///   - row: Вставляемая строка
    ///   - index: Индекс вставки
    public func insert(row: RowConfigurable, at index: Int) {
        rows.insert(row, at: index)
    }
    
    /// Вставка строк в секцию
    ///
    /// - Parameters:
    ///   - rows: Вставляемые строки
    ///   - index: Начиная с какого индекса вставлять
    public func insert(rows: [RowConfigurable], at index: Int) {
        self.rows.insert(contentsOf: rows, at: index)
    }
    
    /// Удалить строку по индексу
    ///
    /// - Parameter index: Индекс удаляемой строки
    /// - Returns: Удаленная строка
    @discardableResult
    public func remove(rowAt index: Int) -> RowConfigurable {
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
    public subscript(id: Int) -> RowConfigurable? {
        get {
            return self["\(id)"]
        }
    }

    /// Найдет и вернет строку с переданным id или nil иначе
    ///
    /// - Parameter id: Идентификатор строки
    public subscript(id: String) -> RowConfigurable? {
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
        guard lhs.headerString == rhs.headerString else { return false }
        guard lhs.headerHeight == rhs.headerHeight else { return false }
        guard lhs.headerView == rhs.headerView else { return false }
        guard lhs.footerString == rhs.footerString else { return false }
        guard lhs.footerHeight == rhs.footerHeight else { return false }
        guard lhs.footerView == rhs.footerView else { return false }
        return true
    }

    // MARK: - BatchUpdateSection
    func getRows() -> [DeepHashable] {
        return rows
    }
}
