import UIKit

class ProfileViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var tagCV: UICollectionView!
    //
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet var menuViewList: [UIView]!
    @IBOutlet var menuLabelList: [UILabel]!
    @IBOutlet weak var tagsView: UIView_hTags!
    //
    @IBOutlet weak var tableView: UITableView_contentSized!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var infoLabel: UILabel!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { self.popVC() }
    @IBAction func moreButtonPressed(_ sender: UIButton) { tapMore(sender) }
    @IBAction func contactSocialButtonPressed(_ sender: UIButton) { contactSocial(sender.tag) }
    // MARK: - Variables
    var user: User = appService.user
    var tagMenu: Int = 1
    var tagList: [Tag] = []
    var fullList: [Post] = []
    var list: [Post] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTapGestureRecognizer()
        setupUIView_tags()
        setupTableView()
        setupCollectionView()
        setupFormData()
        setupUI()
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        // author
        backButton.isHidden = user.isMe
        headerLabel.text = "@\(user.nick ?? "")"
        photoImageView.image = appService.userAva ?? UIImage.userAvaFake
        //photoImageView.load_kf("https://avatar.iran.liara.run/public/boy")
        nameLabel.text = user.name
        nickLabel.text = "@\(user.nick ?? "")"
        infoLabel.text = user.info
        setupFormData_menu()
    }
    private func setupFormData_menu() {
        setupUI_menuView()
        setupUIView_tags()
        tableView.isHidden = !([1, 2].contains(tagMenu))
        menuStackView.isHidden = !([1, 2].contains(tagMenu))
        infoStackView.isHidden = !([3].contains(tagMenu))
        
        switch tagMenu {
        case 1, 2: //Туториалы, Идеи
            fetchData_list()
        case 3: //Инфо
            ()
        default: break
        }
    }
    private func setupFormData_list() {
        list = fullList
        //setupUI_emptyData()
        tableView.reloadData()
    }
    
    // MARK: - Actions
    private func tapMore(_ sender: UIView) {
        var miList: [PopUpMenuItem] = []
        let mi_signOut = PopUpMenuItem(title: "Выйти из аккаунта")
        let mi_report = PopUpMenuItem(title: "Пожаловаться")
        
        if user.isMe {
            miList.append(mi_signOut)
        } else {
            miList.append(mi_report)
        }
        
        guard !miList.isEmpty else { return }
        
        UIView_popUpMenu.showOnView(view: sender, list: miList, menuWidth: 250) { (mi, row) in
            switch mi {
            case mi_signOut: 
                User.signOut_lite()
                appRoute.setRootVC_welcomeVC()
            case mi_report: ()
            default: ()
            }
        }
    }
    private func contactSocial(_ tag: Int) {
        switch tag {
        case 1: SharedService.open_wwwOrApp("https://vk.com/lchok", self)
        case 2: SharedService.open_wwwOrApp("https://t.me/loochok_media", self)
        default: break
        }
    }

    // MARK: - SetupUI
    private func setupUI() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Screen.saB, right: 0)
        scrollView.bounces = false
        userView.decorateView_roundBorder(24, UIColor("000000"), 3)
        userView.clipsToBounds = true
        photoImageView.decorateView_roundBorder(35, UIColor("000000"), 3)
    }
    private func setupUI_menuView() {
        menuViewList.forEach { $0.backgroundColor = ($0.tag == tagMenu) ? UIColor("000000") : UIColor("EDEDEF") }
        menuLabelList.forEach { $0.textColor = ($0.tag == tagMenu) ? UIColor("FFFFFF") : UIColor("000000") }
    }

    // MARK: - Navigation
}

// MARK: - setupTapGestureRecognizer
extension ProfileViewController {
    private func setupTapGestureRecognizer() {
        menuViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_menuView))) }
    }
    @objc private func tap_menuView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag, tag != tagMenu else { return }
        dismissKeyboard()
        tagMenu = tag
        setupFormData_menu()
    }
}

// MARK: - UIView_tags
extension ProfileViewController {
    private func setupUIView_tags() {
        let tagFullList: [Tag] = Tag.thingList
        tagList = [tagFullList.first].compactMap({$0})
        tagsView.isHidden = tagFullList.isEmpty
        
        tagsView.list = tagFullList
        tagsView.selectList = tagList
        tagsView.limit = 1//tagFullList.count
        tagsView.tagCV.reloadData()
        tagsView.tagCV.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tagsView.didTap = { [weak self] (tag) in
            guard let self else { return }
            let isSelect = self.tagList.map({$0.id}).contains(tag.tagId)
            self.tagList.removeAll()
            if isSelect { self.tagList = self.tagList.filter({$0.id != tag.tagId}) }
            else {
                guard let tag = tag as? Tag else { return }
                self.tagList.append(tag)
            }
            self.tagsView.selectList = self.tagList
            self.tagsView.tagCV.reloadData()
            self.setupFormData_list()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCellNib(TutorialTableViewCell.className)
        tableView.registerCellNib(IdeaTableViewCell.className)
        tableView.constraints.filter { $0.identifier == "Delete" }.forEach { $0.isActive = false }
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tagMenu {
        case 1, 2: list.count
        default: 0
        }
    }
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = list[indexPath.row]
        switch tagMenu {
        case 1:
            let cell: TutorialTableViewCell = tableView.getCell()
            cell.item = item
            cell.configureCell()
            cell.didSelect = { self.dismissKeyboard(); appRoute.goToTutorialVC(item) }
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
        case 2:
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
        default: return UITableViewCell()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setupCollectionView() {
        tagCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tagCV.delegate = self
        tagCV.dataSource = self
        tagCV.bounces = false
        tagCV.registerCellNib(TagCollectionViewCell.className)
        tagCV.constraints.filter { $0.identifier == "Delete" }.forEach { $0.isActive = false }
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = CGSize(width: 70, height: 32)
        tagCV.collectionViewLayout = layout
    }
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.tagList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let list = user.tagList
        let item = list[indexPath.row]
        let cell: TagCollectionViewCell = collectionView.getCell(indexPath)
        cell.item = item
        cell.configureCell()
        return cell
    }
    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: API - Tutorial
extension ProfileViewController {
    // postList
    private func fetchData_list() {
        var dict: JSON = [:]
        dict["userId"] = user.id
        
        self.hudShow()
        API.postList { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()

            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let list):
                switch sSelf.tagMenu {
                case 1: sSelf.fullList = list.filter({$0.type == .tutorial})
                case 2: sSelf.fullList = list.filter({$0.type == .idea})
                default: sSelf.fullList.removeAll()
                }
                sSelf.setupFormData_list()
                print("postList: \(sSelf.fullList.count)")
            }
        }
    }
}
