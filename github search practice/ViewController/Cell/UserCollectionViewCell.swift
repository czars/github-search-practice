//
//  UserCollectionViewCell.swift
//  github search practice
//
//  Created by Paul.Chou on 2020/2/11.
//  Copyright © 2020 Paul.Chou. All rights reserved.
//

import UIKit
import Kingfisher

class UserCollectionViewCell: UICollectionViewCell {
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[image]-4-[label]-8-|", options: [.alignAllLeading, .alignAllTrailing], metrics: nil, views: ["image": avatarImageView, "label": nameLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[image]-8-|", options: [.alignAllLeading, .alignAllTrailing], metrics: nil, views: ["image": avatarImageView]))
        nameLabel.textAlignment = .center
        nameLabel.textColor = .darkGray
        nameLabel.backgroundColor = .clear
        avatarImageView.backgroundColor = .clear
        avatarImageView.contentMode = .scaleAspectFit
        
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        avatarImageView.image = nil
    }
    
    func setContent(with user: User) {
        nameLabel.text = user.name
        avatarImageView.kf.setImage(with: URL(string: user.avatarUrl))
        
    }
}
