import UIKit

open class TableRowSwitch: TableRow<TableSwitchCell> { }

// MARK: - ViewModel
open class TableSwitchCellVM: CellVM, Equatable {
    public typealias ChangeActionType = (TableSwitchCellVM) -> Void
    // MARK: Variables
    public var title: String = "" {
        didSet { view?.configure(with: self) }
    }
    public var isOn: Bool = false {
        didSet { view?.configure(with: self) }
    }
    public var isEnabled: Bool = true {
        didSet { view?.configure(with: self) }
    }
    public var changeAction: ChangeActionType?
    
    // MARK: Init
    public init(title: String, isOn: Bool) {
        self.title = title
        self.isOn = isOn
        super.init(action: nil, userInfo: nil)
        
        self.isSelectable = false
    }
    
    // MARK: RowHeightComputable
    override open var defaultHeight: CGFloat? {
        return 44
    }
    
    public static func == (lhs: TableSwitchCellVM, rhs: TableSwitchCellVM) -> Bool {
        guard lhs.title == rhs.title else { return false }
        return true
    }
    
    // MARK: Setters
    public func setChangeAction(_ block: TableSwitchCellVM.ChangeActionType?) {
        changeAction = block
    }
}

// MARK: - Cell
open class TableSwitchCell: UITableViewCell, ConfigurableCell {
    public typealias ViewModelType = TableSwitchCellVM
    
    // MARK: Variables
    public var viewModel: TableSwitchCellVM?
    
    // MARK: UI
    let lbTitle: UILabel = UILabel()
    let vwSwitch: UISwitch = UISwitch()
    
    // MARK: Init
    #if swift(>=4.2)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    #else
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    #endif
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        vwSwitch.isOn = false
        lbTitle.text = nil
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        vwSwitch.frame.origin = CGPoint(x: contentView.frame.width - 16 - vwSwitch.frame.width,
                                        y: (contentView.frame.height - vwSwitch.frame.height) / 2.0)
        
        let textWidth = contentView.frame.width - 32 - 8 - vwSwitch.frame.width
        let textHeight = lbTitle.sizeThatFits(CGSize(width: textWidth, height: contentView.frame.height)).height
        lbTitle.frame = CGRect(x: 16, y: 0, width: textWidth, height: textHeight)
        lbTitle.center.y = contentView.frame.height / 2.0
    }
    
    // MARK: Configure
    private func configure() {
        contentView.addSubview(lbTitle)
        contentView.addSubview(vwSwitch)
        
        vwSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    // MARK: ConfigurableCell
    public func configure(with viewModel: ViewModelType) {
        lbTitle.text = viewModel.title
        vwSwitch.setOn(viewModel.isOn, animated: true)
        vwSwitch.isEnabled = viewModel.isEnabled
    }
    
    // MARK: Actions
    @objc
    private func switchChanged() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.isOn = vwSwitch.isOn
        viewModel.changeAction?(viewModel)
    }
}
