import UIKit
import RKTableAdapter

class CollectionVC: UIViewController {
    // MARK: - Variables
    lazy var collectionAdapter = CollectionViewAdapter(collectionView: collectionView)

    // MARK: - UI
    lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 10
        flow.minimumLineSpacing = 10
        flow.sectionInset.top = 20
        flow.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flow)
        cv.backgroundColor = .white
        return cv
    }()

    // MARK: - Init / Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupCollectionAdapter()
        configureCollectionAdapterContent()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    // MARK: - Configure
    private func configure() {
        configureNavigationBar()
        view.backgroundColor = .white

        collectionView.frame = view.bounds
        view.addSubview(collectionView)
    }

    private func configureNavigationBar() {
        title = "Main"

        let btn1 = UIBarButtonItem(title: "1", style: .plain, target: self, action: #selector(action1))
        let btn2 = UIBarButtonItem(title: "2", style: .plain, target: self, action: #selector(action2))
        navigationItem.setRightBarButtonItems([btn1, btn2], animated: true)
    }

    // MARK: - Actions
    @objc
    func action1() {
        let collectionList = DataGenerator.generateCollectionViewModels1()

        collectionAdapter.reload(with: collectionList)
    }

    @objc
    func action2() {
        let collectionList = DataGenerator.generateCollectionViewModels2()

        collectionAdapter.reload(with: collectionList)
    }

    // MARK: - CollectionAdapter
    private func setupCollectionAdapter() {

    }

    private func configureCollectionAdapterContent() {
        let collectionList = DataGenerator.generateCollectionViewModels1()

        collectionAdapter.reload(with: collectionList)
    }

    // MARK: CollectionAdapter Make sections

    // MARK: CollectionAdapter Actions

    // MARK: - Private
}
