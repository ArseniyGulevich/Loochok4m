import UIKit

class IdeaViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ideaStackView: UIStackView!
    @IBOutlet weak var authorAvaImageView: UIImageView!
    @IBOutlet weak var authorNickLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorLikeCountLabel: UILabel!
    @IBOutlet weak var authorLikeDateLabel: UILabel!
    @IBOutlet weak var authorTagsView: UIView_hTags!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postInfoLabel: UILabel!
    @IBOutlet weak var postPhotoImageView: UIImageView!
    @IBOutlet weak var commentTV: UITableView!
    @IBOutlet weak var commentTextField: UITextField_app!
    @IBOutlet weak var tutorialStackView: UIStackView!
    @IBOutlet weak var tutorialCV: UICollectionView!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { self.popVC() }
    @IBAction func moreButtonPressed(_ sender: UIButton) { tapMore(sender) }
    @IBAction func commentSendButtonPressed(_ sender: UIButton) { commentSend() }
    // MARK: - Variables
    var post: Post!
    var commentList: [Comment] = []
    var tutorialList: [Post] = []
    
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
        postPhotoImageView.load_kf(post.pathPhoto)
        postNameLabel.text = post.title
        postInfoLabel.text = post.description
        // Comment
        fetchData_commentList()
        fetchData_postList()
    }
    
    // MARK: - Actions
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
        ideaStackView.roundCorners(20, [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        postPhotoImageView.round_iv(20)
    }

    // MARK: - Navigation
}

// MARK: - UITextFieldDelegate
extension IdeaViewController: UITextFieldDelegate {
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
extension IdeaViewController {
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
extension IdeaViewController: UITableViewDataSource, UITableViewDelegate {
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
extension IdeaViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    var cvW: CGFloat { Screen.width - (2*16) } //176+124...=300
    var cvH: CGFloat { ((Screen.width-(2*16)-(2*8))/16*9+12+56+8+32+(2*8)+26).rounded(.towardZero) }
    //(368-16)=352/16*9=198+(2*8)+12+(56+8+32)=198+124=322+26=348
    private func setupCollectionView() {
        //ideaCV.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tutorialCV.delegate = self
        tutorialCV.dataSource = self
        tutorialCV.bounces = false
        tutorialCV.isPagingEnabled = true
        tutorialCV.registerCellNib(TutorialCollectionViewCell.className)
        setupCVLayout_tutorialCV()
        
        tutorialCV.constraints.first(where: {($0.firstAttribute == .height) && ($0.relation == .equal)})?.constant = cvH
    }
    private func setupCVLayout_tutorialCV() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cvW, height: cvH)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        tutorialCV!.collectionViewLayout = layout
    }
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = tutorialList[indexPath.row]
        let cell: TutorialCollectionViewCell = collectionView.getCell(indexPath)
        cell.item = item
        cell.configureCell()
        cell.didSelect = { self.dismissKeyboard(); appRoute.goToTutorialVC(item) }
        cell.didTapLike = { [weak self] in
            guard let self else { return }
            self.dismissKeyboard()
            let isLike = !item.isLike
            self.tutorialList.first(where: {$0 == item})?.isLike = isLike
            self.tutorialCV.reloadItems(at: [indexPath])
            //QW-sonra = api for change like
        }
        return cell
    }
}

// MARK: API - Tutorial
extension IdeaViewController {
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
                sSelf.tutorialList = list.filter({($0.type == .tutorial) && ($0.user.id == sSelf.post.user.id) })
                sSelf.tutorialCV.reloadData()
                sSelf.tutorialStackView.isHidden = sSelf.tutorialList.isEmpty
                print("postList: \(list.count)")
            }
        }
    }
}
