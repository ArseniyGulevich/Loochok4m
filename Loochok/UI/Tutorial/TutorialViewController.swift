import UIKit

class TutorialViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var authorAvaImageView: UIImageView!
    @IBOutlet weak var authorNickLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorLikeCountLabel: UILabel!
    @IBOutlet weak var authorLikeDateLabel: UILabel!
    @IBOutlet weak var authorTagsView: UIView_hTags!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postInfoLabel: UILabel!
    @IBOutlet weak var postPhotoImageView: UIImageView!
    @IBOutlet weak var madeStackView: UIStackView!
    @IBOutlet weak var madeHeaderLabel: UILabel!
    @IBOutlet weak var madeTextLabel: UILabel!
    @IBOutlet weak var contactAvaImageView: UIImageView!
    @IBOutlet weak var contactNickLabel: UILabel!
    @IBOutlet weak var contactCommentLabel: UILabel!
    @IBOutlet weak var contactDateLabel: UILabel!
    @IBOutlet weak var commentTV: UITableView!//_contentSized!
    @IBOutlet weak var commentTextField: UITextField_app!
    @IBOutlet weak var ideaStackView: UIStackView!
    @IBOutlet weak var ideaCV: UICollectionView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { self.popVC() }
    @IBAction func moreButtonPressed(_ sender: UIButton) { tapMore(sender) }
    @IBAction func contactReplyButtonPressed(_ sender: UIButton) { () }
    @IBAction func contactSocialButtonPressed(_ sender: UIButton) { contactSocial(sender.tag) }
    @IBAction func commentSendButtonPressed(_ sender: UIButton) { commentSend() }
    // MARK: - Variables
    var post: Post!
    var commentList: [Comment] = []
    var ideaList: [Post] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTextField()
        setupUIView_tags()
        setupTableView()
        setupCollectionView()
        setupUI()
        setupFormData()
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        // author
        headerLabel.text = "@chiveskella"
        authorAvaImageView.load_kf("https://avatar.iran.liara.run/public/boy")
        authorNickLabel.text = "@chiveskella"
        authorNameLabel.text = "Имя Фамилия"
        authorLikeCountLabel.text = "\(123) likes"
        authorLikeDateLabel.text = Date().timeTitle
        // post
        postNameLabel.text = post.title
        postInfoLabel.text = post.description
        postPhotoImageView.load_kf(post.pathPhoto)
        // made
        madeHeaderLabel.text = "Как сделать"
        madeTextLabel.text = post.description
        // contact
        contactAvaImageView.load_kf("https://avatar.iran.liara.run/public/boy")
        contactNickLabel.text = "@chiveskella"
        contactCommentLabel.text = "Круто вышло"
        contactDateLabel.text = Date().toString(.date_ddMMyyyy)
        // Comment
        fetchData_commentList()
        fetchData_postList()
    }
    
    // MARK: - Actions
    private func contactSocial(_ tag: Int) {
        switch tag {
        case 1: SharedService.open_wwwOrApp("https://vk.com/lchok", self)
        case 2: SharedService.open_wwwOrApp("https://t.me/loochok_media", self)
        default: break
        }
    }
    private func tapMore(_ sender: UIView) {
        let isMyPost: Bool = (post.user.id == appService.user?.id)
        
        var miList: [PopUpMenuItem] = []
        let mi_delete = PopUpMenuItem(title: "Удалить")
        let mi_edit = PopUpMenuItem(title: "Редактировать")
        let mi_report = PopUpMenuItem(title: "Пожаловаться")
        let mi_copyLink = PopUpMenuItem(title: "Скопировать ссылку")
        let mi_share = PopUpMenuItem(title: "Поделиться")
        
        if isMyPost {
            miList.append(mi_delete)
            miList.append(mi_edit)
        } else {
            miList.append(mi_report)
        }
        
        miList.append(mi_copyLink)
        miList.append(mi_share)
        
        guard !miList.isEmpty else { return }
        
        UIView_popUpMenu.showOnView(view: sender, list: miList, menuWidth: 250) { [weak self] (mi, row) in
            guard let sSelf = self else { return }
            switch mi {
            case mi_delete:
                sSelf.displayAlertYesNo("Вы уверены?", nil) { (isYes) in
                    guard isYes else { return }
                    ()
                }
            case mi_edit: ()
            case mi_report: ()
            case mi_copyLink:
                guard let path = sSelf.post.link else { return }
                path.copyToClipBoard()
            case mi_share: SharedService.shared(sSelf, sSelf.post.title, sSelf.postPhotoImageView.image, sSelf.post.link)
            default: ()
            }
        }
    }

    // MARK: - SetupUI
    private func setupUI() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Screen.saB, right: 0)
        scrollView.bounces = false
        postPhotoImageView.round_iv(16)
    }

    // MARK: - Navigation
}

// MARK: - UITextFieldDelegate
extension TutorialViewController: UITextFieldDelegate {
    private func setupTextField() {
        
        let tfList = self.view.getSubviewsOfView(type: UITextField_app.self, recursive: true)
        tfList.forEach { (textField) in
            textField.delegate = self
            textField.setupUI_titleLabel()
            textField.errorLabel?.text = nil
            textField.didUpdate = { () }
            textField.didUpdateEnd = { () }
        }
    }
    @objc func tapDone() { dismissKeyboard() }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case commentTextField: dismissKeyboard()
        default: ()
        }
        return true
    }
}

// MARK: - UIView_tags
extension TutorialViewController {
    private func setupUIView_tags() {
        let authorTagList: [Tag] = Tag.tagList
        authorTagsView.isHidden = authorTagList.isEmpty
        
        authorTagsView.list = authorTagList
        authorTagsView.selectList = authorTagList
        authorTagsView.limit = authorTagList.count
        authorTagsView.tagCV.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TutorialViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableView() {
        commentTV.delegate = self
        commentTV.dataSource = self
        commentTV.tableFooterView = UIView()
        commentTV.rowHeight = UITableView.automaticDimension
        commentTV.registerCellNib(CommentTableViewCell.className)
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = commentList[indexPath.row]
        let cell: CommentTableViewCell = tableView.getCell()
        cell.item = item
        cell.configureCell()
        cell.didSelect = { self.dismissKeyboard() }
        cell.didTapComment = { }
        return cell
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TutorialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    var cvW: CGFloat { Screen.width - (2*16) }
    var cvH: CGFloat { Screen.width-(2*16)+12+121 }
    private func setupCollectionView() {
        //ideaCV.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        ideaCV.delegate = self
        ideaCV.dataSource = self
        ideaCV.bounces = false
        ideaCV.isPagingEnabled = true
        ideaCV.registerCellNib(IdeaCollectionViewCell.className)
        setupCVLayout_ideaCV()
        
        ideaCV.constraints.first(where: {($0.firstAttribute == .height) && ($0.relation == .equal)})?.constant = cvH
    }
    private func setupCVLayout_ideaCV() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cvW, height: cvH)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        ideaCV!.collectionViewLayout = layout
    }
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ideaList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = ideaList[indexPath.row]
        let cell: IdeaCollectionViewCell = collectionView.getCell(indexPath)
        cell.item = item
        cell.configureCell()
        cell.didSelect = { self.dismissKeyboard(); appRoute.goToIdeaVC(item) }
        cell.didTapLike = { [weak self] in
            guard let self else { return }
            self.dismissKeyboard()
            let isLike = !item.isLike
            self.ideaList.first(where: {$0 == item})?.isLike = isLike
            self.ideaCV.reloadItems(at: [indexPath])
            //QW-sonra = api for change like
        }
        return cell
    }
}

// MARK: API - Tutorial
extension TutorialViewController {
    // commentList
    private func fetchData_commentList() {
        var dict: JSON = [:]
        dict["postId"] = post.id
        
        self.hudShow()
        API.commentList(dict) { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()

            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let list):
                sSelf.commentList = list
                sSelf.commentTV.reloadData()
                sSelf.commentTV.isHidden = list.isEmpty
                print("commentList: \(list.count)")
            }
        }
    }
    // commentSend
    private func commentSend() {
        dismissKeyboard()
        guard let text = commentTextField.text, !text.isEmpty else { return }

        var dict: JSON = [:]
        dict["bode"] = text
        
        commentTextField.text = nil

//        self.hudShow()
//        API.commentSend(dict) { [weak self] (result) in
//            guard let sSelf = self else { return }
//            sSelf.hudHide()
//            switch result {
//            case .failure(let error): error.run(sSelf)
//            case .success(let dict):
//            }
//        }
    }
    // postList
    private func fetchData_postList() {
        self.hudShow()
        API.postList { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()

            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let list):
                sSelf.ideaList = list.filter({($0.type == .idea) && ($0.user.id == sSelf.post.user.id) })
                sSelf.ideaCV.reloadData()
                sSelf.ideaStackView.isHidden = sSelf.ideaList.isEmpty
                print("postList: \(list.count)")
            }
        }
    }
}
