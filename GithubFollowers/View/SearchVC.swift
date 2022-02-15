//
//  SearchVC.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/6/22.
//

import UIKit

class SearchVC: UIViewController {
    
    private var stackView = UIStackView()
    private var imageView = UIImageView()
    private var searchUserTF = UITextField()
    private var gitHubLabel = UILabel()
    private var followersLabel = UILabel()
    private var getFollowersButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        configure()
        constrain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchUserTF.text = ""
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchUserTF.resignFirstResponder()
    }
    
    func configure() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        imageView.image = UIImage(named: "gitHubLogo")
        gitHubLabel.attributedText = NSAttributedString(string: "GitHub", attributes: [.font: UIFont.systemFont(ofSize: 50, weight: .bold), .foregroundColor: UIColor.black])
        gitHubLabel.textAlignment = .center
        followersLabel.attributedText = NSAttributedString(string: "Followers", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .regular), .foregroundColor: UIColor.black])
        followersLabel.textAlignment = .center

        searchUserTF.textAlignment = .center
        searchUserTF.layer.borderWidth = 1.0
        searchUserTF.layer.borderColor = UIColor.lightGray.cgColor
        searchUserTF.layer.cornerRadius = 10.0
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                          .font: UIFont.systemFont(ofSize: 30)]
        searchUserTF.attributedPlaceholder = NSAttributedString(string: "Enter UserName", attributes: attributes)
        searchUserTF.font = UIFont.systemFont(ofSize: 30)
        searchUserTF.delegate = self
        searchUserTF.returnKeyType = UIReturnKeyType.done
        
        getFollowersButton.setTitle("Get Followers", for: .normal)
        getFollowersButton.backgroundColor = .systemGreen
        getFollowersButton.layer.cornerRadius = 10.0
        getFollowersButton.addTarget(self, action: #selector(getFollowersButtonAction), for: .touchUpInside)
        
        view.addConstrainedSubviews(imageView, stackView, searchUserTF, getFollowersButton)
        stackView.addArrangedSubviews(gitHubLabel, followersLabel)
    }
    
    func constrain() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchUserTF.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            searchUserTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchUserTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchUserTF.heightAnchor.constraint(equalToConstant: 50),
            getFollowersButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            getFollowersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            getFollowersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            getFollowersButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func getFollowersButtonAction(sender: UIButton) {
        guard let text = searchUserTF.text else {
            return
        }
        if text.count > 0 {
            let followerListVC = FollowerListVC()
            followerListVC.userName = searchUserTF.text
            self.navigationController?.pushViewController(followerListVC, animated: true)
        }
    }
}

extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.getFollowersButtonAction(sender: getFollowersButton)
        return true
    }
}
