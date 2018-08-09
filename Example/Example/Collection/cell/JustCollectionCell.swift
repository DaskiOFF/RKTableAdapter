import UIKit
import RKTableAdapter

class JustCollectionCell: UICollectionViewCell, ConfigurableCell {
    typealias ViewModelType = JustCollectionCellVM

    // MARK: - Properties
    var viewModel: ViewModelType?

    // MARK: - UI
    let textLabel: UILabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

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

    override func layoutSubviews() {
        super.layoutSubviews()

        updateLabel()
    }

    // MARK: - Configure
    private func configure() {
        contentView.addSubview(textLabel)
        
        contentView.backgroundColor = .red
    }

    // MARK: - ConfigurableCell
    func configure(with viewModel: ViewModelType) {
        self.textLabel.text = viewModel.title

        updateLabel()
    }

    // MARK: - Actions

    // MARK: - Private
    private func updateLabel() {
        textLabel.sizeToFit()
        textLabel.center = contentView.center
    }
}
