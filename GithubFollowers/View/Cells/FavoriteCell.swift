//
//  FavoriteCell.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/6/22.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    static let identifier = "FavoriteCell"
    
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    private let followersViewModel = FollowersViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        constrain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        accessoryType = .disclosureIndicator
        nameLabel.font = UIFont.systemFont(ofSize: 30)
        addConstrainedSubviews(iconImageView, nameLabel)
    }
    
    func constrain() {
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func populateCellWithData(favorite: Follower) {
        nameLabel.text = favorite.login
        followersViewModel.downloadUserImage(for: favorite.avatarUrl) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.iconImageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
