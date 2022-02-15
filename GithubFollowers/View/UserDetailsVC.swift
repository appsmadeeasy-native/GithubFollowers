//
//  UserDetailsVC.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/15/22.
//

import UIKit
import SafariServices

protocol GitHubUserDetailDelegate: AnyObject {
    func didTapGitHubFollowersButton()
    func didTapGitHubProfileButton()
}

class UserDetailsVC: UIViewController {
    
    var follower: Follower?
    var followerImage: UIImage?
    private let doneButton = UIButton(type: .custom)
    private let svForFirstSection = UIStackView()
    private let svForSecondSection = UIStackView()
    private let svForThirdSection = UIStackView()
    private let descriptionLabel = UILabel()
    private let userImage = UIImageView()
    private let svFirstRightNameLocation = UIStackView()
    private let membershipSinceLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let fullNameLabel = UILabel()
    private let locationLabel = UILabel()
    private let locationImageView = UIImageView()
    private let followersViewModel = FollowersViewModel()
    private let profileView = GithubView.init()
    private let followersView = GithubView.init()
    private let locationStackView = UIStackView()
    
    weak var gitHubFollowersDelegate: GitHubFollowersDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        guard let login = follower?.login else {
            return
        }
        
        followersViewModel.getUserDetails(for: login) { [weak self] hasData in
            if hasData {
                DispatchQueue.main.async {
                    self?.configure()
                    self?.constrain()
                }
            }
        }
    }
    
    private func configure() {
        configureFirstSection()
        configureDescriptionSection()
        configureSecondSection()
        configureMembershipSince()
        configureDoneButton()
    }
    
    private func configureFirstSection() {
        svForFirstSection.axis = .horizontal
        svForFirstSection.spacing = 10
        svForFirstSection.distribution = .fill
        view.addConstrainedSubview(svForFirstSection)
        
        userImage.layer.cornerRadius = 10
        userImage.clipsToBounds = true
        userImage.image = followerImage
        loginNameLabel.attributedText = NSAttributedString(string: follower!.login, attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .bold), .foregroundColor: UIColor.black])
        fullNameLabel.text = followersViewModel.user?.name
        fullNameLabel.textColor = .secondaryLabel
        locationImageView.image = UIImage(systemName: "mappin.and.ellipse")
        locationImageView.tintColor = .secondaryLabel
        locationLabel.text = followersViewModel.user?.location ?? "No Location"
        locationLabel.textColor = .secondaryLabel
        
        svFirstRightNameLocation.axis = .vertical
        svFirstRightNameLocation.spacing = 5
        svFirstRightNameLocation.distribution = .fill
        svFirstRightNameLocation.addArrangedSubviews(loginNameLabel, fullNameLabel, locationStackView)
        
        locationStackView.axis = .horizontal
        locationStackView.spacing = 5
        locationStackView.distribution = .fill
        locationStackView.addArrangedSubviews(locationImageView, locationLabel)
        svForFirstSection.addArrangedSubviews(userImage, svFirstRightNameLocation)
    }
    
    private func constrainFirstSection() {
        NSLayoutConstraint.activate([
            svForFirstSection.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 30),
            svForFirstSection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            svForFirstSection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            svForFirstSection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            svFirstRightNameLocation.widthAnchor.constraint(equalTo: svForFirstSection.widthAnchor, multiplier: 0.75),
            locationImageView.widthAnchor.constraint(equalTo: locationStackView.widthAnchor, multiplier: 0.07),
        ])
    }
    
    private func configureDescriptionSection() {
        descriptionLabel.text = followersViewModel.user?.bio ?? "No Bio available"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        view.addConstrainedSubview(descriptionLabel)
    }

    private func constrainDescriptionSection() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: svForFirstSection.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            descriptionLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }
    
    private func configureSecondSection() {
        svForSecondSection.axis = .vertical
        svForSecondSection.spacing = 20
        svForSecondSection.distribution = .fillEqually
        view.addConstrainedSubview(svForSecondSection)
        profileView.gitHubUserDetailDelegate = self
        profileView.populateItemsWithData(sectionType: .profile,
                                          leftCount: followersViewModel.user?.publicRepos ?? 0,
                                          rightCount: followersViewModel.user?.publicGists ?? 0)
        followersView.gitHubUserDetailDelegate = self
        followersView.populateItemsWithData(sectionType: .followers,
                                            leftCount: followersViewModel.user?.followers ?? 0,
                                            rightCount: followersViewModel.user?.following ?? 0)
        svForSecondSection.addArrangedSubviews(profileView, followersView)
    }
    
    private func constrainSecondSection() {
        NSLayoutConstraint.activate([
            svForSecondSection.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            svForSecondSection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            svForSecondSection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            svForSecondSection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
    }
    
    private func configureMembershipSince() {
        guard let membershipStartDate = followersViewModel.user?.createdAt.toMonthAndYear() else {
            return
        }
        membershipSinceLabel.attributedText = NSAttributedString(string: "GitHub since " + membershipStartDate, attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .regular), .foregroundColor: UIColor.black])
        membershipSinceLabel.textAlignment = .center
        view.addConstrainedSubview(membershipSinceLabel)
    }
    
    private func constrainMembershipSince() {
        NSLayoutConstraint.activate([
            membershipSinceLabel.topAnchor.constraint(equalTo: svForSecondSection.bottomAnchor, constant: 30),
            membershipSinceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            membershipSinceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func constrain() {
        constrainFirstSection()
        constrainDescriptionSection()
        constrainSecondSection()
        constrainMembershipSince()
        constrainDoneButton()
    }
    
    private func configureDoneButton() {
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.systemBlue, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        view.addConstrainedSubview(doneButton)
    }
    
    private func constrainDoneButton() {
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            doneButton.heightAnchor.constraint(equalToConstant: 25),
            doneButton.widthAnchor.constraint(equalToConstant: 80)
            ])
    }
    

    @objc func doneButtonAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserDetailsVC: GitHubUserDetailDelegate {
    func didTapGitHubProfileButton() {
        guard let htmlUrl = followersViewModel.user?.htmlUrl,
                let url = URL(string: htmlUrl) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemTeal
        present(safariVC, animated: true)
    }
    
    func didTapGitHubFollowersButton() {
        guard let userName = follower?.login else {
            return
        }
        gitHubFollowersDelegate.didTapGitHubFollowersButton(name: userName)
        dismiss(animated: true, completion: nil)
    }
}
