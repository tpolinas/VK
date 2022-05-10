//
//  NewsVC.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 30.03.2022.
//

import UIKit
import RealmSwift

class NewsVC: UITableViewController {
    private enum Identifier: Int {
        case top
        case text
        case image
        case bottom
    }
    
    private let networkService = NetworkService<News>()
    private var userNews = [News]() {
            didSet {
            for index in userNews.indices {
                let indexPath: IndexPath = [index, 1]
                textCellState[indexPath] = true
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    static var nextFrom: String?
    private let newsService = NewsService.instance
    private var isLoading = false
    private var textCellState = [IndexPath : Bool]()
    private var indexOfCell: Identifier?
    private var anotherQueue: DispatchQueue = DispatchQueue.init(
                                                label: "anotherQueue")
    private var oneMoreQueue: DispatchQueue = DispatchQueue.init(
                                                label: "oneMoreQueue")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        
        anotherQueue.sync {
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = UITableView.automaticDimension
        }
        
        setup()
        setupRefreshControl()
        
        self.oneMoreQueue.sync {
            networkService.fetch(type: .feed) { [weak self] result in
                switch result {
                case .success(let myNews):
                    myNews.forEach() { index in
                        guard let attachment = index.photosURLs else { return }
                        attachment.forEach { item in
                            guard item.type == "photo" else { return }
                            let new = News(
                                sourceID: index.sourceID,
                                date: index.date,
                                text: index.text ?? "",
                                photosURLs: attachment,
                                likes: index.likes,
                                reposts: index.reposts,
                                comments: index.comments)
                            guard !self!.userNews.contains(new) else { return }
                        self?.userNews.append(new)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return userNews.count
    }

    private let newsCellCount: Int = 4
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        var number = newsCellCount
        if userNews[section].text == nil { number -= 1 }
        if userNews[section].photosURLs == nil { number -= 1 }
        return number
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let news = userNews[indexPath.section]
        switch indexPath.row {
        case 0:
            indexOfCell = .top
        case 1:
            indexOfCell = (news.text == nil) ? .image : .text
        case 2:
            indexOfCell = (news.photosURLs == nil) || news.text == nil
            ? .bottom : .image
        case 3:
            indexOfCell = .bottom
        default:
            indexOfCell = .none
        }
        
        switch indexOfCell {
        case .top:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsTopCell.self,
                forIndexPath: indexPath)
            else { return UITableViewCell() }
            let group = loadGroupByID(news.sourceID)
            guard
                group?.avatar != nil
            else { return UITableViewCell() }
            
            cell.configure(
                avatar: group!.avatar,
                name: group!.name,
                newsTime: news.date.toString(
                                    dateFormat: .dateTime))
            
            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsTextCell.self,
                forIndexPath: indexPath)
            else { return UITableViewCell() }
            
            guard
                let textIsTruncated = textCellState[indexPath]
            else { return cell }
            
            cell.configure(
                text: news.text ?? "",
                indexPath: indexPath,
                textIsTruncated: textIsTruncated)
            
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell
        case .image:
            var photos = [String]()
            news.photosURLs?.forEach({ index in
                guard let photoURL = index.photo?.sizes.last?.url else { return }
                
                photos.append(photoURL)
            })
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsImagesCollection.self,
                forIndexPath: indexPath)
            else { return UITableViewCell() }
            
            cell.currentNews = nil
            cell.photoURLs = []
            
            cell.currentNews = news
            cell.photoURLs = photos

            return cell
        case .bottom:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NewsBottom.self,
                forIndexPath: indexPath)
            else { return UITableViewCell() }

            cell.configure(
                isLiked: false,
                likesCounter: news.likes.count,
                commentsCounter: news.comments.count,
                sharedCounter: news.reposts.count)

            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    public func loadGroupByID(_ id: Int) -> Group? {
        do {
            let realmGroups: [GroupRealm] = try RealmService.load(
                typeOf: GroupRealm.self)
            if let group = realmGroups.filter({ $0.id == -id }).first {
                return Group(
                        id: group.id,
                        name: group.name,
                        avatar: group.avatar)
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .cyan
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        tableView.refreshControl?.addTarget(
            self,
            action: #selector(refreshNews),
            for: .valueChanged)
    }

    @objc private func refreshNews() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.newsService.getNews {
                self.oneMoreQueue.sync {
                    self.userNews = self.newsService.userNews
                }
            }
        }
        self.tableView.refreshControl?.endRefreshing()
    }
    
    override func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if indexPath.row == Identifier.text.rawValue {
            if userNews[indexPath.section].text == "" {
                return 0
            }
        }
        if indexPath.row == Identifier.image.rawValue {
            guard
                let height = NewsImagesCollection.collectionHeight[indexPath]
            else {
                return UITableView.automaticDimension
                
            }
            return height
        }
        return UITableView.automaticDimension
    }
    
    private func setup() {
        tableView.sectionHeaderTopPadding = 0
        tableView.registerWithNib(registerClass: NewsTopCell.self)
        tableView.registerWithNib(registerClass: NewsTextCell.self)
        tableView.registerWithNib(registerClass: NewsImagesCollection.self)
        tableView.registerWithNib(registerClass: NewsBottom.self)
    }
}

extension NewsVC: UICollectionViewDelegate,
                  UIGestureRecognizerDelegate { }

extension NewsVC: ExpandableLabelDelegate {
    func didPressButton(at indexPath: IndexPath) {
        print(indexPath)
        guard let state = textCellState[indexPath] else { return }
        textCellState[indexPath] = !state
        tableView.reloadRows(
            at: [indexPath],
            with: .none)
    }
}

extension NewsVC: UITableViewDataSourcePrefetching {
    func tableView(
        _ tableView: UITableView,
        prefetchRowsAt indexPaths: [IndexPath]
    ) {
        guard
            let maxSection = indexPaths.map({ $0.section }).max()
        else { return }
        if maxSection > self.userNews.count - 5, !isLoading {
            isLoading = true
            DispatchQueue.global(qos: .background).async {
                self.newsService.getNews(nextFrom: NewsVC.nextFrom) {
                    self.userNews += self.newsService.userNews
                    self.isLoading = false
                }
            }
        }
    }
}
