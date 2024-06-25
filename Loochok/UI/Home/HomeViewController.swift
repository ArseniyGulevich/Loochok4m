import UIKit

class HomeViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var searchTextField: UITextField_search!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bannerCV: UICollectionView!
    @IBOutlet weak var weekTV: UITableView_contentSized!
    @IBOutlet weak var popularTV: UITableView_contentSized!
    // MARK: - IBAction
    @IBAction func filterButtonPressed(_ sender: UIButton) { () }
    // MARK: - Variables
    var bannerList: [Banner] = Banner.demoList
    var postList: [Post] = []
    var weekList: [Post] = []
    var popularList: [Post] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTextField()
        setupTableView()
        setupCollectionView()
        setupUI()
        setupFormData()
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        fetchData_postList()
    }
    private func setupFormData_list() {
        let searchText = searchTextField.textStr.lowercased()
        if searchText.isEmpty {
            bannerList = Banner.demoList
            weekList = Array(postList.filter({$0.type == .tutorial}).prefix(2))
            popularList = Array(postList.filter({$0.type == .idea}).prefix(5))
        } else {
            bannerList = Banner.demoList.filter({$0.filterText.contains(searchText)})
            weekList = Array(postList.filter({$0.type == .tutorial}).prefix(2))
            weekList = weekList.filter({$0.filterText.contains(searchText)})
            popularList = Array(postList.filter({$0.type == .idea}).prefix(5))
            popularList = popularList.filter({$0.filterText.contains(searchText)})
        }
        bannerCV.isHidden = bannerList.isEmpty
        bannerCV.reloadData()
        weekTV.isHidden = weekList.isEmpty
        weekTV.reloadData()
        popularTV.isHidden = popularList.isEmpty
        popularTV.reloadData()
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    private func setupTextField() {
        searchTextField.delegate = self
        searchTextField.didUpdate = { self.updateListByFilters() }
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case searchTextField: updateListByFilters(); dismissKeyboard()
        default: ()
        }
        return true
    }
    //
    private func updateListByFilters() { setupFormData_list() }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setupCollectionView() {
        bannerCV.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        bannerCV.delegate = self
        bannerCV.dataSource = self
        bannerCV.bounces = false
        bannerCV.registerCellNib(BannerCollectionViewCell.className)
        setupCVLayout_bannerCV()
    }
    private func setupCVLayout_bannerCV() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 210, height: 210)
        layout.minimumInteritemSpacing = 26
        layout.minimumLineSpacing = 26
        layout.scrollDirection = .horizontal
        bannerCV!.collectionViewLayout = layout
    }
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case bannerCV: return bannerList.count
        default: return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let item = bannerList[row]
        let cell: BannerCollectionViewCell = collectionView.getCell(indexPath)
        cell.item = item
        cell.configureCell()
        cell.didSelect = {  }
        return cell
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        // weekTV
        weekTV.delegate = self
        weekTV.dataSource = self
        weekTV.tableFooterView = UIView()
        weekTV.rowHeight = UITableView.automaticDimension
        weekTV.registerCellNib(TutorialTableViewCell.className)
        // popularTV
        popularTV.delegate = self
        popularTV.dataSource = self
        popularTV.tableFooterView = UIView()
        popularTV.rowHeight = UITableView.automaticDimension
        popularTV.registerCellNib(IdeaTableViewCell.className)
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case weekTV: weekList.count
        case popularTV: popularList.count
        default: 0
        }
    }
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case weekTV:
            let item = weekList[indexPath.row]
            let cell: TutorialTableViewCell = tableView.getCell()
            cell.item = item
            cell.configureCell()
            cell.didSelect = { self.dismissKeyboard(); appRoute.goToTutorialVC(item) }
            cell.didTapLike = { [weak self] in
                guard let self else { return }
                self.dismissKeyboard()
                let isLike = !item.isLike
                self.weekList.first(where: {$0 == item})?.isLike = isLike
                self.postList.first(where: {$0 == item})?.isLike = isLike
                tableView.reloadRows(at: [indexPath], with: .none)
                //QW-sonra = api for change like
            }
            return cell
        case popularTV:
            let item = popularList[indexPath.row]
            let cell: IdeaTableViewCell = tableView.getCell()
            cell.item = item
            cell.configureCell()
            cell.didSelect = { self.dismissKeyboard(); appRoute.goToTutorialVC(item) }
            cell.didTapLike = { [weak self] in
                guard let self else { return }
                self.dismissKeyboard()
                let isLike = !item.isLike
                self.popularList.first(where: {$0 == item})?.isLike = isLike
                self.postList.first(where: {$0 == item})?.isLike = isLike
                tableView.reloadRows(at: [indexPath], with: .none)
                //QW-sonra = api for change like
            }
            return cell
        default: return UITableViewCell()
        }
    }
}

// MARK: API - Tutorial
extension HomeViewController {
    // postList
    private func fetchData_postList() {
        self.hudShow()
        API.postList { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()

            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let list):
                sSelf.postList = list
                sSelf.setupFormData_list()
                print("postList: \(list.count)")
            }
        }
    }
}
