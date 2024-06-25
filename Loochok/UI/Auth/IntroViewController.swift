import UIKit

class IntroViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton_gradientV!
    // MARK: - IBAction
    @IBAction func nextButtonPressed(_ sender: UIButton) { nextPage(2) }
    // MARK: - Variables
    var list: [IntroData] = IntroData.list
    private var isAnimate: Bool = false
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        setupFormData()
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        pageControl.numberOfPages = list.count
        setupFormData_page()
    }
    private func setupFormData_page() {
        guard let row = collectionView.centerRow else { return }
        pageControl.currentPage = row
        setupUI_nextButton()
    }
    
    // MARK: - Actions
    private func skipIntro() {
        ldService.isWasIntro = true
        appRoute.goToApp()
    }
    private func nextPage(_ tag: Int) {
        guard !isAnimate, let row = collectionView.centerRow else { return }
        guard (0 <= row) && (row < list.count) else { return }
        let rowNext = row + ((tag==1) ? -1 : +1)
        guard rowNext < list.count else { skipIntro(); return }
        isAnimate = true
        collectionView.scrollPageToRow(rowNext, true)
    }

    // MARK: - SetupUI
    private func setupUI() {
        setupUI_nextButton()
    }
    private func setupUI_nextButton() {
        let row = collectionView.centerRow ?? 0
        nextButton.setTitle((row<(list.count-1)) ? "ПРОДОЛЖИТЬ" : "К ЛУЧКУ!", for: .normal)
    }

    // MARK: - Navigation
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension IntroViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.registerCellNib(IntroCollectionViewCell.className)
        setupCollectionViewLayout()
    }
    private func setupCollectionViewLayout() {
        let widthCVCell = Screen.width
        let heightCVCell = collectionView.frame.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: widthCVCell, height: heightCVCell)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView!.collectionViewLayout = layout
    }
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = list[indexPath.row]
        let cell: IntroCollectionViewCell = collectionView.getCell(indexPath)
        cell.item = item
        cell.configureCell()
        return cell
    }
    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    // UIScrollViewDelegate - to update the UIPageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        setupFormData_page()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        isAnimate = false
        setupFormData_page()
    }
}

class IntroData: Codable {
    var id: Int
    var title: String
    var photoNameTop: String
    var photoNameMain: String
    
    // MARK: - Initializers
    init?(json: JSON?) {
        guard let json = json,
              let id = json["id"] as? Int,
              let title = json["title"] as? String,
              let photoNameTop = json["photoNameTop"] as? String,
              let photoNameMain = json["photoNameMain"] as? String
        else { return nil }
        
        self.id = id
        self.title = title
        self.photoNameTop = photoNameTop
        self.photoNameMain = photoNameMain
    }
    // loadList
    static func loadList(_ jsonList: [JSON]?) -> [IntroData] {
        guard let jsonList = jsonList else { return [] }
        let list = jsonList.compactMap { IntroData.init(json: $0) }
        return list
    }
    
    // Data
    static var list: [IntroData] {
        var dictList: [JSON] = []
        dictList.append(["id": 1,
                         "title": "Вдохновляйся идеями",
                         "photoNameTop": "intro1H.pdf",
                         "photoNameMain": "intro1M.pdf"])
        dictList.append(["id": 2,
                         "title": "Читай туториалы и учись новому",
                         "photoNameTop": "intro2H.pdf",
                         "photoNameMain": "intro2M.pdf"])
        dictList.append(["id": 3,
                         "title": "Пробуй и расскажи о себе",
                         "photoNameTop": "intro3H.pdf",
                         "photoNameMain": "intro3M.pdf"])
        
        return IntroData.loadList(dictList)
    }
}
