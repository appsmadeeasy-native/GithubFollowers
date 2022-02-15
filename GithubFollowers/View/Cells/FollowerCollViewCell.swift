//
//  FollowerCell.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/6/22.
//

import UIKit

class FollowerCollViewCell: UICollectionViewCell {
    
    static let identifier = "FollowerCell"

    let imageView = UIImageView()
    let nameLabel = UILabel()
    private let followersViewModel = FollowersViewModel()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor.systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(follower: Follower) {
        nameLabel.text = follower.login
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        
        followersViewModel.downloadUserImage(for: follower.avatarUrl) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        addConstrainedSubviews(nameLabel, imageView)
        constrain()
    }
    
    private func constrain() {

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.85),
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
