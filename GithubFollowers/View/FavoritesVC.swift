//
//  FavoritesVC.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/6/22.
//

import UIKit

class FavoritesVC: UIViewController {
    
    var favorites: [Follower] = []
    
    let favoriteTableView: UITableView = {
        let table = UITableView()
        table.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        return table
    }()
    
    var dataSource: UITableViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favorites"
        
        favoriteTableView.delegate = self
        dataSource = createDiffableDataSource()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavoritesFromStore()
    }
    
    private func loadFavoritesFromStore() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    
                } else {
                    self?.favorites = favorites
                    DispatchQueue.main.async {
                        self?.updateDataSourceForFavorites()
                    }
                }
            case .failure(let error):
                print("Error occurred \(error.localizedDescription)")
            }
        }
    }

    private func configure() {
        view.addSubview(favoriteTableView)
        favoriteTableView.rowHeight = 100
        favoriteTableView.frame = view.bounds
    }

    private func createDiffableDataSource() -> UITableViewDiffableDataSource<Section, Follower> {
        
        return UITableViewDiffableDataSource<Section, Follower>(tableView: self.favoriteTableView) { tableView, indexPath, model -> FavoriteCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as! FavoriteCell
            cell.populateCellWithData(favorite: model)
            return cell
        }
    }
    
    private func updateDataSourceForFavorites() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.first])
        snapshot.appendItems(favorites)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension FavoritesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let followerListVC = FollowerListVC()
        followerListVC.userName = favorite.login
        navigationController?.pushViewController(followerListVC, animated: true)
    }
}
