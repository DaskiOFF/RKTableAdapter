import UIKit
import RKTableAdapter

class JustCell: UITableViewCell, ConfigurableCell {
    typealias ViewModelType = JustCellVM

    // MARK: - Properties
    var viewModel: ViewModelType?

    // MARK: - UI

    // MARK: - Init
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    // MARK: - Configure
    private func configure() {

    }

    // MARK: - ConfigurableCell
    func configure(with viewModel: ViewModelType) {
        self.textLabel?.text = viewModel.title
    }

    // MARK: - Actions
}
