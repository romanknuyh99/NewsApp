//
//  ViewController.swift
//  NewsApp
//
//  Created by Roman Kniukh on 21.03.21.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Variables
    private lazy var manager = NewsManager()
    private lazy var date = Date()
    private lazy var rowCount = 0
    private lazy var items: [Article] = []
    private lazy var filteredNews: [Article] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private lazy var dateCount = 1
    private lazy var makeRequest: Bool = false
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - GUI Variables
    private var collectionView: UICollectionView?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        self.navigationController?.navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        
        return searchController
    }()

    // MARK: - Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let imageHeight = UIScreen.main.bounds.width * 9 / 16
        layout.itemSize = CGSize(width: (view.frame.width)-20, height: imageHeight + 200)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 2
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {
            return
        }
        collectionView.register(NewsCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .lightGray
        manager.onCompletion = { data in
            DispatchQueue.main.async {
                self.items += data.articles.compactMap { $0.value }
                self.collectionView?.reloadData()
            }
        }
        manager.fetchNews(date: date)
    }
    
    private func loadMoreData() {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
        self.date = previousDate!
        self.dateCount += 1
        self.manager.fetchNews(date: self.date)
    }
    
    // MARK: - Actions
    @objc private func reload() {
        self.items = []
        self.rowCount = 0
        self.date = Date()
        self.manager.fetchNews(date: self.date)
        self.collectionView?.reloadData()
    }
}

// MARK: - ViewController extensions

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return self.filteredNews.count
        } else {
            return self.items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier,
                                                            for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item: Article = isFiltering
            ? self.filteredNews[indexPath.row]
            : items[indexPath.row]

        let stringToDateFormatter = DateFormatter()
        stringToDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = stringToDateFormatter.date(from: item.publishedAt)
        let dateToStringFormatter = DateFormatter()
        dateToStringFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        var dateString = ""
        if let date = date {
            dateString = dateToStringFormatter.string(from: date)
        }
        cell.configure(description: item.articleDescription,
                       title: item.title,
                       image: item.urlToImage,
                       date: dateString
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.items.count - 4,
           self.dateCount <= 7,
           self.makeRequest == false {
            self.loadMoreData()
        }
    }
}

// MARK: - Search Bar Delegate, ResultsUpdating
extension ViewController: UISearchResultsUpdating,
                          UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = self.searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        self.filteredNews = self.items.filter({ (news: Article) -> Bool in
            return news.title.lowercased().contains(searchText.lowercased())
        })
        collectionView?.reloadData()
        if items.count != 0 {
            collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}
