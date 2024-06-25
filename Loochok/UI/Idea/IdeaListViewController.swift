import UIKit

class IdeaListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var searchTextField: UITextField_search!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagsView: UIView_hTags!
    // MARK: - IBAction
    @IBAction func filterButtonPressed(_ sender: UIButton) { () }
    // MARK: - Variables
    var fullList: [Post] = []
    var list: [Post] = []
    var tagList: [Tag] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTextField()
        setupUIView_tags()
        setupTableView()
        setupUI()
        setupFormData()
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        fetchData_list()
    }
    private func setupFormData_list() {
        let searchText = searchTextField.textStr.lowercased()
        if searchText.isEmpty { list = fullList }
        else { list = fullList.filter({$0.filterText.contains(searchText)}) }
        setupUI_emptyData()
        tableView.reloadData()
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        setupUI_emptyData(true)
    }
    private func setupUI_emptyData(_ allHide: Bool = false) {
        tableView.isHidden = allHide || list.isEmpty
        //emptyDataView.isHidden = allHide || !list.isEmpty
    }

    // MARK: - Navigation
}

// MARK: - UITextFieldDelegate
extension IdeaListViewController: UITextFieldDelegate {
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

// MARK: - UIView_tags
extension IdeaListViewController {
    private func setupUIView_tags() {
        let tagFullList: [Tag] = Tag.thingList
        tagList = [tagFullList.first].compactMap({$0})
        tagsView.isHidden = tagFullList.isEmpty
        
        tagsView.list = tagFullList
        tagsView.selectList = tagList
        tagsView.limit = tagFullList.count
        tagsView.tagCV.reloadData()
        tagsView.didTap = { [weak self] (tag) in
            guard let self else { return }
            let isSelect = self.tagList.map({$0.id}).contains(tag.tagId)
            if isSelect { self.tagList = self.tagList.filter({$0.id != tag.tagId}) }
            else {
                guard let tag = tag as? Tag else { return }
                self.tagList.append(tag)
            }
            self.tagsView.selectList = self.tagList
            self.tagsView.tagCV.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension IdeaListViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(IdeaTableViewCell.className)
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list[indexPath.row]
        let cell: IdeaTableViewCell = tableView.getCell()
        cell.item = item
        cell.configureCell()
        cell.didSelect = { self.dismissKeyboard(); appRoute.goToIdeaVC(item) }
        cell.didTapLike = { [weak self] in
            guard let self else { return }
            self.dismissKeyboard()
            let isLike = !item.isLike
            self.list.first(where: {$0 == item})?.isLike = isLike
            self.fullList.first(where: {$0 == item})?.isLike = isLike
            self.tableView.reloadRows(at: [indexPath], with: .none)
            //QW-sonra = api for change like
        }
        return cell
    }
}

// MARK: API - Tutorial
extension IdeaListViewController {
    // postList
    private func fetchData_list() {
        self.hudShow()
        API.postList { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()

            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let list):
                sSelf.fullList = list.filter({$0.type == .idea})
                sSelf.setupFormData_list()
                print("postList: \(list.count)")
            }
        }
    }
}
