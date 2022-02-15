//
//  GithubView.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/15/22.
//

import UIKit

enum SectionType {
    case profile, followers
}

class GithubView: UIView {
    
    private var leftItemName = UILabel()
    private var leftItemNumber = UILabel()
    private var leftImageView = UIImageView()
    private var rightItemName = UILabel()
    private var rightItemNumber = UILabel()
    private var rightImageView = UIImageView()
    private var longButton = UIButton(type: .custom)
    
    weak var gitHubUserDetailDelegate: GitHubUserDetailDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 18
        backgroundColor = .secondarySystemBackground
        configure()
        constrain()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        leftItemName.font = UIFont.boldSystemFont(ofSize: 14)
        leftItemNumber.font = UIFont.boldSystemFont(ofSize: 14)
        rightItemName.font = UIFont.boldSystemFont(ofSize: 14)
        rightItemNumber.font = UIFont.boldSystemFont(ofSize: 14)
        longButton.layer.cornerRadius = 10
        longButton.setTitleColor(.white, for: .normal)
        addConstrainedSubviews(leftImageView, leftItemName, leftItemNumber,
                               rightImageView, rightItemName, rightItemNumber, longButton)
    }
    
    private func constrain() {
        NSLayoutConstraint.activate([
            leftImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            leftItemName.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            leftItemName.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 10),
            leftItemNumber.topAnchor.constraint(equalTo: leftItemName.bottomAnchor, constant: 10),
            leftItemNumber.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            rightImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            rightImageView.trailingAnchor.constraint(equalTo: rightItemName.leadingAnchor, constant: -15),
            rightItemName.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            rightItemName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            rightItemNumber.topAnchor.constraint(equalTo: rightItemName.bottomAnchor, constant: 10),
            rightItemNumber.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            longButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            longButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            longButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            longButton.heightAnchor.constraint(equalToConstant: 45)
            ])
    }
    
    func populateItemsWithData(sectionType: SectionType, leftCount: Int, rightCount: Int) {
        switch sectionType {
        case .profile:
            leftImageView.image = UIImage(systemName: "folder")
            leftImageView.tintColor = .black
            leftItemName.text = "Public Repos"
            leftItemNumber.text = String(leftCount)
            rightImageView.image = UIImage(systemName: "text.alignleft")
            rightImageView.tintColor = .black
            rightItemName.text = "Public Gists"
            rightItemNumber.text = String(rightCount)
            longButton.backgroundColor = .systemPurple
            longButton.setTitle("GitHub Profile", for: .normal)
            longButton.addTarget(self, action: #selector(gitHubProfileButtonAction), for: .touchUpInside)
        case .followers:
            leftImageView.image = UIImage(systemName: "heart")
            leftImageView.tintColor = .black
            leftItemName.text = "Followers"
            leftItemNumber.text = String(leftCount)
            rightImageView.image = UIImage(systemName: "person.2")
            rightImageView.tintColor = .black
            rightItemName.text = "Following"
            rightItemNumber.text = String(rightCount)
            longButton.backgroundColor = .systemBlue
            longButton.setTitle("Get Followers", for: .normal)
            longButton.addTarget(self, action: #selector(gitHubFollowersButtonAction), for: .touchUpInside)
        }
    }
    
    @objc func gitHubProfileButtonAction(sender: UIButton) {
        gitHubUserDetailDelegate.didTapGitHubProfileButton()
    }
    
    @objc func gitHubFollowersButtonAction(sender: UIButton) {
        gitHubUserDetailDelegate.didTapGitHubFollowersButton()
    }
}
