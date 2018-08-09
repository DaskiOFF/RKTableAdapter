import UIKit

class ViewController: UIViewController {
    // MARK: - Variables

    // MARK: - UI
    lazy var btnTable: UIButton = {
        let btn = UIButton(type: .system)

        btn.setTitle("Table", for: .normal)
        btn.addTarget(self, action: #selector(openTable), for: .touchUpInside)
        return btn
    }()
    lazy var btnCollection: UIButton = {
        let btn = UIButton(type: .system)

        btn.setTitle("Collection", for: .normal)
        btn.addTarget(self, action: #selector(openCollection), for: .touchUpInside)
        return btn
    }()

    // MARK: - Init / Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    // MARK: - Configure
    private func configure() {
        configureNavigationBar()
        view.backgroundColor = .white

        view.addSubview(btnTable)
        btnTable.sizeToFit()
        btnTable.center = view.center
        btnTable.center.y -= 40

        view.addSubview(btnCollection)
        btnCollection.sizeToFit()
        btnCollection.center = view.center
    }

    private func configureNavigationBar() {
        title = "Main"
    }

    // MARK: - Actions
    @objc
    func openTable() {
        let vc = TableVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func openCollection() {
        let vc = CollectionVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Private
}
