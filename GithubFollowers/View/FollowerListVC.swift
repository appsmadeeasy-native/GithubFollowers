//
//  FolloweListVC.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/6/22.
//

import UIKit

protocol GitHubFollowersDelegate: AnyObject {
    func didTapGitHubFollowersButton(name: String)
}

class FollowerListVC: UIViewController {
    
    var userName: String?
    private var activityView: UIActivityIndicatorView?
    private let searchController = UISearchController(searchResultsController: nil)
    private var filtered: [Follower]?
    private var searchActive : Bool = false
    
    private var myCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(FollowerCollViewCell.self, forCellWithReuseIdentifier: FollowerCollViewCell.identifier)
        return collectionView
    }()
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    private let followersViewModel = FollowersViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAddFavorite(sender:)))
        
        configure()
        constrain()
        guard let name = userName else {
            return
        }
        getGitFollowersFromCloud(name: name)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func getGitFollowersFromCloud(name: String) {
        title = name
        
        showActivityIndicator()
        
        // Do any additional setup after loading the view.
        followersViewModel.getGitFollowers(for: name) { [weak self] hasData in
            if hasData {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                    self?.updateDataSource(followers: self?.filtered)
                }
            }
        }
    }
    
    @objc func didTapAddFavorite(sender: UIBarButtonItem) {
        guard let name = userName else {
            return
        }
        followersViewModel.getUserDetails(for: name) { [weak self] hasData in
            if hasData {
                guard let avatarUrl = self?.followersViewModel.user?.avatarUrl else {
                    return
                }
                let favorite = Follower(login: name, avatarUrl: avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let error = error else {
                        DispatchQueue.main.async {
                            print("Success")
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                    }
                    
                }
            } else {
                DispatchQueue.main.async {
                    print("Error found!")
                }
            }
        }
    }
    
    private func configure() {
        let backButton = UIBarButtonItem()
        backButton.title = "Search"
        backButton.tintColor = .systemGreen
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.prefersLargeTitles = true

        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        
        myCollectionView.delegate = self
        diffableDataSource = createDiffableDataSource()

        let layout = configureCollectionLayout()
        myCollectionView.setCollectionViewLayout(layout, animated: true)
        myCollectionView.backgroundColor = .white
        
        configureSearchController()
        
        view.addConstrainedSubviews(myCollectionView)
        myCollectionView.addConstrainedSubview(activityView!)
    }
    
    private func configureCollectionLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let followerItem = NSCollectionLayoutItem(layoutSize: itemSize)
        followerItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: followerItem, count: 3)

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func constrain() {
        NSLayoutConstraint.activate([
            myCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            myCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityView!.centerYAnchor.constraint(equalTo: myCollectionView.centerYAnchor),
            activityView!.centerXAnchor.constraint(equalTo: myCollectionView.centerXAnchor),
        ])
    }
    
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search for a username"
        searchController.searchBar.becomeFirstResponder()
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    func createDiffableDataSource() -> UICollectionViewDiffableDataSource<Section, Follower> {
        
        return UICollectionViewDiffableDataSource<Section, Follower>(collectionView: self.myCollectionView) { collectionView, indexPath, model -> FollowerCollViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCollViewCell.identifier, for: indexPath) as! FollowerCollViewCell
            
            cell.configure(follower: model)
            return cell
        }
    }
    
    func updateDataSource(followers: [Follower]?) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.first])
        if let followers = followers {
            snapshot.appendItems(followers)
        } else {
            snapshot.appendItems(self.followersViewModel.followers)
        }
        diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    func showActivityIndicator() {
        activityView?.isHidden = false
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
            activityView?.isHidden = true
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, filter.isEmpty == false else {
            filtered?.removeAll()
            updateDataSource(followers:self.followersViewModel.followers)
            searchActive = false
            return
        }
        
        searchActive = true
        filtered = followersViewModel.followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateDataSource(followers: filtered)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var follower: Follower?
        if searchActive {
            guard let filtered = filtered else {
                return
            }
            follower = filtered[indexPath.item] 
        } else {
            follower = followersViewModel.followers[indexPath.item]
        }
        
        let userDetailsVC = UserDetailsVC()
        userDetailsVC.gitHubFollowersDelegate = self
        userDetailsVC.follower = follower
        if let cell = collectionView.cellForItem(at: indexPath) as? FollowerCollViewCell {
            userDetailsVC.followerImage = cell.imageView.image
        }
        navigationController?.present(userDetailsVC, animated: true, completion: nil)
    }
}

extension FollowerListVC: GitHubFollowersDelegate {
    func didTapGitHubFollowersButton(name: String) {
        getGitFollowersFromCloud(name: name)
    }
}

enum Section {
    case first
}
